# frozen_string_literal: true

require "shellwords"

module Wf
  class Lola
    attr_reader :end_p, :start_p, :workflow

    class << self
      def configured_binary
        ENV["WF_LOLA_BIN"].presence || Wf.lola_bin
      end

      def bundled_binary
        Rails.root.join("tmp", "lola-prefix", "bin", "lola").to_s
      end

      def resolve_binary
        configured = configured_binary
        return configured.to_s if configured.present?

        bundled = bundled_binary
        return bundled if File.executable?(bundled)

        "lola"
      end

      def binary_available?(binary)
        return false if binary.blank?

        if binary.to_s.include?(File::SEPARATOR)
          File.executable?(binary.to_s)
        else
          system("which", binary.to_s, out: File::NULL, err: File::NULL)
        end
      end
    end

    def initialize(workflow)
      @workflow = workflow
      @start_p  = workflow.places.start.first
      @end_p    = workflow.places.end.first
      generate_lola_file!
    end

    def to_text
      places      = workflow.places
      transitions = workflow.transitions

      places_text  = places.map(&:lola_id).join(",")
      marking_text = start_p.lola_id
      # TODO: with guard
      transitions_text = transitions.map do |t|
        consume = t.arcs.in.map { |arc| "#{arc.place.lola_id}:1" }.join(",")
        produce = t.arcs.out.map { |arc| "#{arc.place.lola_id}:1" }.join(",")
        [
          "TRANSITION #{t.lola_id}",
          "CONSUME #{consume};",
          "PRODUCE #{produce};"
        ].join("\n")
      end.join("\n\n")

      <<~LOLA
        PLACE #{places_text};

        MARKING #{marking_text};

        #{transitions_text}
      LOLA
    end

    def json_path(bucket)
      Rails.root.join("tmp", "#{workflow.id}-#{bucket}.json")
    end

    def lola_path
      Rails.root.join("tmp", "#{workflow.id}-#{workflow.updated_at.to_i}.lola")
    end

    def generate_lola_file!
      File.write(lola_path, to_text) unless File.exist?(lola_path)
    end

    def soundness?
      reachability_of_final_marking? && quasiliveness? && !deadlock?
    end

    def reachability_of_final_marking?
      formula = workflow.places.reject { |p| p == end_p }.map { |p| "#{p.lola_id} = 0" }.join(" AND ")
      formula += " AND #{end_p.lola_id} >= 1"
      formula = "AGEF(#{formula})"
      result = run_cmd(formula, "reachability_of_final_marking")
      result.dig("analysis", "result")
    end

    def quasiliveness?
      workflow.transitions.all? { |t| !dead_transition?(t) }
    end

    def deadlock?
      formula = "EF (DEADLOCK AND (#{end_p.lola_id} = 0))"
      result = run_cmd(formula, "deadlock")
      result.dig("analysis", "result")
    end

    private

      def dead_transition?(transition)
        formula = "AG NOT FIREABLE (#{transition.lola_id})"
        result = run_cmd(formula, "dead_transition_#{transition.id}")
        result.dig("analysis", "result")
      end

      def run_cmd(formula, bucket)
        binary = self.class.resolve_binary
        result_path = json_path(bucket)
        File.delete(result_path) if File.exist?(result_path)

        cmd = [
          binary.to_s,
          lola_path.to_s,
          "--markinglimit=1000",
          "--timelimit=1",
          "--formula=#{formula}",
          "--json=#{result_path}"
        ]
        $stdout.puts cmd.map { |part| Shellwords.escape(part) }.join(" ")

        success = system(*cmd)
        unless success && File.exist?(result_path)
          raise("LoLA command failed with '#{binary}'. Run `bundle exec rake app:wf:lola:doctor` for diagnostics.")
        end

        JSON.parse(File.read(result_path))
      end
  end
end
