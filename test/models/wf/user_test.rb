# frozen_string_literal: true

# == Schema Information
#
# Table name: wf_users
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer
#

require "test_helper"

module Wf
  class UserTest < ActiveSupport::TestCase
    test "user belongs to group and creates party" do
      group = create_group
      user = create_user(group: group)

      assert_equal group, user.group
      assert_not_nil user.party
      assert_equal "name", user.party.party_name
    end
  end
end
