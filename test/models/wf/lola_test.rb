# frozen_string_literal: true

require "test_helper"
require "fileutils"
require "minitest/mock"
require "securerandom"

module Wf
  class LolaTest < ActiveSupport::TestCase
    test "to_text renders places and transitions" do
      workflow, transition = build_linear_workflow
      lola = Wf::Lola.new(workflow)

      text = lola.to_text

      assert_includes text, "PLACE"
      assert_includes text, "MARKING #{workflow.places.start.first.lola_id};"
      assert_includes text, "TRANSITION #{transition.lola_id}"
      assert_includes text, "CONSUME"
      assert_includes text, "PRODUCE"
    end

    test "run_cmd parses valid json output" do
      workflow, = build_linear_workflow
      lola = Wf::Lola.new(workflow)
      bucket = "lola-test-#{SecureRandom.hex(4)}"
      formula = "EF (DEADLOCK)"
      json_path = lola.json_path(bucket)
      captured_cmd = nil

      stubbed_system = lambda do |cmd|
        captured_cmd = cmd
        FileUtils.mkdir_p(json_path.dirname)
        File.write(json_path, JSON.dump({ analysis: { result: true } }))
        true
      end

      result = nil
      lola.stub(:system, stubbed_system) do
        result = lola.send(:run_cmd, formula, bucket)
      end

      assert_equal true, result.dig("analysis", "result")
      assert_includes captured_cmd, "--formula=\"#{formula}\""
      assert_includes captured_cmd, "--json=#{json_path}"
    end

    test "run_cmd raises on malformed json output" do
      workflow, = build_linear_workflow
      lola = Wf::Lola.new(workflow)
      bucket = "lola-test-invalid-#{SecureRandom.hex(4)}"
      formula = "AG NOT FIREABLE (T1)"
      json_path = lola.json_path(bucket)

      stubbed_system = lambda do |_cmd|
        FileUtils.mkdir_p(json_path.dirname)
        File.write(json_path, "{not-json")
        true
      end

      lola.stub(:system, stubbed_system) do
        assert_raises(JSON::ParserError) do
          lola.send(:run_cmd, formula, bucket)
        end
      end
    end

    private

      def build_linear_workflow
        workflow = Wf::Workflow.create!(name: "wf-#{SecureRandom.hex(6)}")
        start_place = workflow.places.create!(name: "start-#{SecureRandom.hex(4)}", place_type: :start)
        end_place = workflow.places.create!(name: "end-#{SecureRandom.hex(4)}", place_type: :end)
        transition = workflow.transitions.create!(name: "transition-#{SecureRandom.hex(4)}", trigger_type: :user)

        workflow.arcs.create!(transition: transition, place: start_place, direction: :in)
        workflow.arcs.create!(transition: transition, place: end_place, direction: :out)

        [workflow, transition]
      end
  end
end
