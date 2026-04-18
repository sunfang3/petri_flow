# frozen_string_literal: true

require "test_helper"

module Wf
  class StaticAssignmentsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "create static assignment for transition" do
      flow = build_linear_workflow
      transition = flow[:transition]
      party = create_user.party

      assert_difference("Wf::TransitionStaticAssignment.count", 1) do
        post transition_static_assignments_path(transition), params: {
          transition_static_assignment: {
            party_id: party.id
          }
        }
      end

      assignment = Wf::TransitionStaticAssignment.order(:id).last
      assert_redirected_to workflow_transition_path(flow[:workflow], transition)
      assert_equal flow[:workflow].id, assignment.workflow_id
    end

    test "destroy removes static assignment" do
      flow = build_linear_workflow
      transition = flow[:transition]
      party = create_user.party
      assignment = transition.transition_static_assignments.create!(party: party)

      assert_difference("Wf::TransitionStaticAssignment.count", -1) do
        delete transition_static_assignment_path(transition, assignment)
      end

      assert_response :success
      assert_includes response.body, "window.location.reload()"
    end
  end
end
