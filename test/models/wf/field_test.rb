# frozen_string_literal: true

# == Schema Information
#
# Table name: wf_fields
#
#  id              :integer          not null, primary key
#  name            :string
#  form_id         :integer
#  position        :integer          default("0")
#  field_type      :integer          default("0")
#  field_type_name :string
#  default_value   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require "test_helper"

module Wf
  class FieldTest < ActiveSupport::TestCase
    test "field_type_for_view maps boolean to check_box" do
      form = create_form
      field = form.fields.create!(name: unique_name("flag"), field_type: :boolean)

      assert_equal "check_box", field.field_type_for_view
    end

    test "array field casts input values" do
      form = create_form
      field = form.fields.create!(name: unique_name("ids"), field_type: "integer[]")

      assert_equal true, field.array?
      assert_equal [1, 2], field.cast(["1", "2"])
    end
  end
end
