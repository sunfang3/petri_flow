# frozen_string_literal: true

# == Schema Information
#
# Table name: wf_transition_static_assignments
#
#  id            :integer          not null, primary key
#  party_id      :integer
#  transition_id :integer
#  workflow_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "test_helper"

module Wf
  class TransitionStaticAssignmentTest < ActiveSupport::TestCase
    test "workflow is copied from transition before validation" do
      flow = build_linear_workflow
      party = create_user.party
      assignment = Wf::TransitionStaticAssignment.create!(transition: flow[:transition], party: party)

      assert_equal flow[:workflow].id, assignment.workflow_id
    end

    test "party uniqueness is scoped by workflow and transition" do
      flow = build_linear_workflow
      party = create_user.party
      Wf::TransitionStaticAssignment.create!(transition: flow[:transition], party: party)

      duplicate = Wf::TransitionStaticAssignment.new(transition: flow[:transition], party: party)

      assert_equal false, duplicate.valid?
      assert_includes duplicate.errors[:party_id], "has already been taken"
    end
  end
end
