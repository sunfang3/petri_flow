# frozen_string_literal: true

require "test_helper"

module Wf
  class ArcsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "new is reachable" do
      workflow = create_workflow

      get new_workflow_arc_path(workflow)

      assert_response :success
    end

    test "create arc with valid params" do
      flow = build_linear_workflow
      workflow = flow[:workflow]

      assert_difference("Wf::Arc.count", 1) do
        post workflow_arcs_path(workflow), params: {
          arc: {
            direction: :in,
            transition_id: flow[:transition].id,
            place_id: flow[:start_place].id
          }
        }
      end

      assert_redirected_to workflow_path(workflow)
    end
  end
end
