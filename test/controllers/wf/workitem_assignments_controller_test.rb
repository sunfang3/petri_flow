# frozen_string_literal: true

require "test_helper"

module Wf
  class WorkitemAssignmentsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "create workitem assignment" do
      flow = create_case_with_workitem
      workitem = flow[:workitem]
      party = create_user.party

      assert_difference("Wf::WorkitemAssignment.count", 1) do
        post workitem_workitem_assignments_path(workitem), params: {
          workitem_assignment: {
            party_id: party.id
          }
        }
      end

      assert_redirected_to workitem_path(workitem)
      assert_equal 1, workitem.reload.workitem_assignments.where(party: party).count
    end

    test "destroy workitem assignment" do
      flow = create_case_with_workitem
      workitem = flow[:workitem]
      party = create_user.party
      assignment = workitem.workitem_assignments.create!(party: party)

      assert_difference("Wf::WorkitemAssignment.count", -1) do
        delete workitem_workitem_assignment_path(workitem, assignment), params: { party_id: party.id }
      end

      assert_response :success
      assert_includes response.body, "window.location.reload()"
    end
  end
end
