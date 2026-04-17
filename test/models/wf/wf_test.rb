# frozen_string_literal: true

require "test_helper"
require "securerandom"

module Wf
  class WfTest < ActiveSupport::TestCase
    test "do_validate marks workflow invalid when start and end places are missing" do
      workflow = Wf::Workflow.create!(name: "invalid-workflow")

      assert_equal false, workflow.reload.is_valid
      assert_includes workflow.error_msg, "must have start place"
      assert_includes workflow.error_msg, "must have end place"
    end

    test "do_validate accepts a minimal linear workflow" do
      workflow = build_linear_workflow(trigger_type: :user)
      workflow.do_validate!

      assert_equal true, workflow.reload.is_valid
      assert_equal "", workflow.error_msg
    end

    private

      def build_linear_workflow(trigger_type:)
        workflow = Wf::Workflow.create!(name: "wf-#{SecureRandom.hex(6)}")
        start_place = workflow.places.create!(name: "start-#{SecureRandom.hex(4)}", place_type: :start)
        end_place = workflow.places.create!(name: "end-#{SecureRandom.hex(4)}", place_type: :end)
        transition = workflow.transitions.create!(name: "transition-#{SecureRandom.hex(4)}", trigger_type: trigger_type)

        workflow.arcs.create!(transition: transition, place: start_place, direction: :in)
        workflow.arcs.create!(transition: transition, place: end_place, direction: :out)

        workflow.reload
      end
  end
end
