# frozen_string_literal: true

# == Schema Information
#
# Table name: wf_demo_targets
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "test_helper"

module Wf
  class DemoTargetTest < ActiveSupport::TestCase
    test "target exposes associated cases" do
      flow = build_linear_workflow
      target = Wf::DemoTarget.create!(name: unique_name("target"), description: "for model test")
      wf_case = flow[:workflow].cases.create!(state: :created, targetable: target)

      assert_includes target.cases, wf_case
    end
  end
end
