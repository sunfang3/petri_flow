# frozen_string_literal: true

# == Schema Information
#
# Table name: wf_workitem_assignments
#
#  id          :integer          not null, primary key
#  party_id    :integer
#  workitem_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "test_helper"

module Wf
  class WorkitemAssignmentTest < ActiveSupport::TestCase
    test "belongs to workitem and party" do
      flow = create_case_with_workitem
      user = create_user
      assignment = Wf::WorkitemAssignment.create!(workitem: flow[:workitem], party: user.party)

      assert_equal flow[:workitem], assignment.workitem
      assert_equal user.party, assignment.party
    end
  end
end
