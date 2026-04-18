# frozen_string_literal: true

require "test_helper"

module Wf
  class CasesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "index is reachable" do
      workflow = create_workflow

      get workflow_cases_path(workflow)

      assert_response :success
    end

    test "destroy removes case" do
      flow = build_linear_workflow
      workflow = flow[:workflow]
      wf_case = workflow.cases.create!(state: :created)

      assert_difference("Wf::Case.count", -1) do
        delete workflow_case_path(workflow, wf_case)
      end

      assert_response :success
      assert_includes response.body, "window.location.reload()"
    end
  end
end
