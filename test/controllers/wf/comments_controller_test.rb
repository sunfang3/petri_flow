# frozen_string_literal: true

require "test_helper"

module Wf
  class CommentsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "new is reachable" do
      create_user
      flow = create_case_with_workitem

      get new_workitem_comment_path(flow[:workitem])

      assert_response :success
    end

    test "create and destroy comment" do
      create_user
      flow = create_case_with_workitem
      workitem = flow[:workitem]

      assert_difference("Wf::Comment.count", 1) do
        post workitem_comments_path(workitem), params: { comment: { body: "hello from controller test" } }
      end
      assert_redirected_to workitem_path(workitem)

      comment = Wf::Comment.order(:id).last
      assert_equal "hello from controller test", comment.body

      assert_difference("Wf::Comment.count", -1) do
        delete workitem_comment_path(workitem, comment)
      end
      assert_response :success
    end
  end
end
