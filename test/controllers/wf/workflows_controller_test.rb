# frozen_string_literal: true

require "test_helper"
require "securerandom"

module Wf
  class WorkflowsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "index is reachable" do
      get workflows_path

      assert_response :success
      assert_includes response.body, "Workflows"
    end

    test "create workflow with valid params" do
      assert_difference("Wf::Workflow.count", 1) do
        post workflows_path, params: {
          workflow: {
            name: "workflow-#{SecureRandom.hex(4)}",
            description: "created from controller test"
          }
        }
      end

      assert_redirected_to workflows_path
    end

    test "create workflow rejects blank name" do
      assert_no_difference("Wf::Workflow.count") do
        post workflows_path, params: { workflow: { name: "", description: "invalid" } }
      end

      assert_response :success
    end

    test "destroy removes workflow" do
      workflow = Wf::Workflow.create!(name: "to-delete-#{SecureRandom.hex(4)}")

      assert_difference("Wf::Workflow.count", -1) do
        delete workflow_path(workflow)
      end

      assert_redirected_to workflows_path
    end
  end
end
