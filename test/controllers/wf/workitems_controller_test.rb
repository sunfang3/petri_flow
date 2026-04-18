# frozen_string_literal: true

require "test_helper"

module Wf
  class WorkitemsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "index is reachable" do
      create_user

      get workitems_path

      assert_response :success
    end

    test "show is reachable for existing workitem" do
      create_user
      flow = create_case_with_workitem

      get workitem_path(flow[:workitem])

      assert_response :success
    end
  end
end
