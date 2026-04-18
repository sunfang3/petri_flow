# frozen_string_literal: true

# == Schema Information
#
# Table name: wf_field_values
#
#  id         :integer          not null, primary key
#  form_id    :integer
#  field_id   :integer
#  value      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entry_id   :integer
#

require "test_helper"

module Wf
  class FieldValueTest < ActiveSupport::TestCase
    test "value_after_cast casts scalar values" do
      user = create_user
      flow = create_case_with_workitem
      form = create_form
      field = form.fields.create!(name: unique_name("score"), field_type: :integer)
      entry = Wf::Entry.create!(form: form, workitem: flow[:workitem], user: user)

      field_value = Wf::FieldValue.create!(form: form, field: field, entry: entry, value: "42")

      assert_equal 42, field_value.value
    end

    test "array field serializes and casts arrays" do
      user = create_user
      flow = create_case_with_workitem
      form = create_form
      field = form.fields.create!(name: unique_name("ids"), field_type: "integer[]")
      entry = Wf::Entry.create!(form: form, workitem: flow[:workitem], user: user)

      field_value = Wf::FieldValue.new(form: form, field: field, entry: entry)
      field_value.value = ["1", "2", "3"]
      field_value.save!

      assert_equal [1, 2, 3], field_value.reload.value
    end
  end
end
