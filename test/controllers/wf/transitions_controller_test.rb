# frozen_string_literal: true

require "test_helper"

module Wf
  class TransitionsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "create transition with valid params" do
      workflow = create_workflow

      assert_difference("Wf::Transition.count", 1) do
        post workflow_transitions_path(workflow), params: {
          transition: {
            name: unique_name("transition"),
            trigger_type: :user
          }
        }
      end

      assert_redirected_to workflow_path(workflow)
    end

    test "update transition changes attributes" do
      flow = build_linear_workflow
      transition = flow[:transition]

      put workflow_transition_path(flow[:workflow], transition), params: {
        transition: {
          name: "updated-transition",
          trigger_type: :automatic
        }
      }

      assert_redirected_to workflow_path(flow[:workflow])
      assert_equal "updated-transition", transition.reload.name
      assert_equal "automatic", transition.trigger_type
    end
  end
end
