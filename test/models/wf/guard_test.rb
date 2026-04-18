# frozen_string_literal: true

# == Schema Information
#
# Table name: wf_guards
#
#  id             :integer          not null, primary key
#  arc_id         :integer
#  workflow_id    :integer
#  fieldable_type :string
#  fieldable_id   :string
#  op             :string
#  value          :string
#  exp            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require "test_helper"

module Wf
  class GuardTest < ActiveSupport::TestCase
    test "exp and fieldable cannot be set together" do
      flow = build_linear_workflow
      form = create_form
      field = form.fields.create!(name: unique_name("guard-field"), field_type: :integer)
      guard = Wf::Guard.new(
        arc: flow[:out_arc],
        fieldable: field,
        exp: "1 + 1",
        op: "=",
        value: "2"
      )

      refute guard.valid?
      assert_includes guard.errors[:exp], "Exp and Fieldable can not be set at the same time."
    end

    test "guard requires either exp or fieldable" do
      flow = build_linear_workflow
      guard = Wf::Guard.new(arc: flow[:out_arc], op: "=", value: "1")

      refute guard.valid?
      assert_includes guard.errors[:exp], "Must set one of Exp and Fieldable."
    end

    test "yes_or_no supports comparison operators" do
      guard = Wf::Guard.new(op: ">=")

      assert_equal true, guard.yes_or_no?(3, 2)
      assert_equal false, guard.yes_or_no?(1, 2)
    end
  end
end
