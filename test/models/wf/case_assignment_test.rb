# frozen_string_literal: true

# == Schema Information
#
# Table name: wf_case_assignments
#
#  id            :integer          not null, primary key
#  case_id       :integer
#  transition_id :integer
#  party_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "test_helper"

module Wf
  class CaseAssignmentTest < ActiveSupport::TestCase
    test "belongs to case transition and party" do
      flow = create_case_with_workitem
      user = create_user
      assignment = Wf::CaseAssignment.create!(case: flow[:wf_case], transition: flow[:transition], party: user.party)

      assert_equal flow[:wf_case], assignment.case
      assert_equal flow[:transition], assignment.transition
      assert_equal user.party, assignment.party
    end
  end
end
