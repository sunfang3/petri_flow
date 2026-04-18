# frozen_string_literal: true

require "test_helper"

module Wf
  class GuardsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "create guard for out arc" do
      flow = build_linear_workflow
      arc = flow[:out_arc]

      assert_difference("Wf::Guard.count", 1) do
        post arc_guards_path(arc), params: {
          guard: {
            op: "=",
            value: "1",
            exp: "1"
          }
        }
      end

      assert_redirected_to workflow_arc_path(flow[:workflow], arc)
      assert_equal flow[:workflow].id, Wf::Guard.order(:id).last.workflow_id
    end

    test "destroy removes guard" do
      flow = build_linear_workflow
      arc = flow[:out_arc]
      guard = arc.guards.create!(workflow: flow[:workflow], op: "=", value: "1", exp: "1")

      assert_difference("Wf::Guard.count", -1) do
        delete arc_guard_path(arc, guard)
      end

      assert_response :success
      assert_includes response.body, "window.location.reload()"
    end
  end
end
