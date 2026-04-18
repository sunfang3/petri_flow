# frozen_string_literal: true

# == Schema Information
#
# Table name: wf_comments
#
#  id          :integer          not null, primary key
#  workitem_id :integer
#  user_id     :string
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "test_helper"

module Wf
  class CommentTest < ActiveSupport::TestCase
    test "belongs to workitem and user" do
      user = create_user
      flow = create_case_with_workitem
      comment = Wf::Comment.create!(workitem: flow[:workitem], user: user, body: "model test comment")

      assert_equal flow[:workitem], comment.workitem
      assert_equal user, comment.user
      assert_equal "model test comment", comment.body
    end
  end
end
