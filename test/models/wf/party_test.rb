# frozen_string_literal: true

# == Schema Information
#
# Table name: wf_parties
#
#  id            :integer          not null, primary key
#  partable_type :string
#  partable_id   :string
#  party_name    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "test_helper"

module Wf
  class PartyTest < ActiveSupport::TestCase
    test "user creates party via acts_as_party" do
      user = create_user

      assert_not_nil user.party
      assert_equal user, user.party.partable
      assert_equal "name", user.party.party_name
    end
  end
end
