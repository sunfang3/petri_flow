# frozen_string_literal: true

require "test_helper"
require "securerandom"

module Wf
  class CaseCommandStartCaseTest < ActiveSupport::TestCase
    test "start case with user transition keeps case active and creates enabled workitem" do
      workflow = build_linear_workflow(trigger_type: :user)
      wf_case = Wf::CaseCommand::New.call(workflow).result

      Wf::CaseCommand::StartCase.call(wf_case)

      wf_case.reload
      workitem = wf_case.workitems.order(:id).last

      assert_predicate wf_case, :active?
      assert_predicate workitem, :enabled?
      assert_equal 1, wf_case.tokens.free.count
      assert_equal workflow.places.start.first.id, wf_case.tokens.free.first.place_id
    end

    test "start case with automatic transition can finish the case" do
      workflow = build_linear_workflow(trigger_type: :automatic)
      wf_case = Wf::CaseCommand::New.call(workflow).result

      Wf::CaseCommand::StartCase.call(wf_case)

      wf_case.reload
      assert_predicate wf_case, :finished?
      assert_equal 1, wf_case.workitems.finished.count
      assert_equal 2, wf_case.tokens.consumed.count
    end

    private

      def build_linear_workflow(trigger_type:)
        workflow = Wf::Workflow.create!(name: "wf-#{SecureRandom.hex(6)}")
        start_place = workflow.places.create!(name: "start-#{SecureRandom.hex(4)}", place_type: :start)
        end_place = workflow.places.create!(name: "end-#{SecureRandom.hex(4)}", place_type: :end)
        transition = workflow.transitions.create!(name: "transition-#{SecureRandom.hex(4)}", trigger_type: trigger_type)

        workflow.arcs.create!(transition: transition, place: start_place, direction: :in)
        workflow.arcs.create!(transition: transition, place: end_place, direction: :out)

        workflow
      end
  end
end
