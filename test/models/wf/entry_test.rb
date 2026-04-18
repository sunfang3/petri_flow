# frozen_string_literal: true

# == Schema Information
#
# Table name: wf_entries
#
#  id          :integer          not null, primary key
#  user_id     :string
#  workitem_id :integer
#  payload     :json             default("{}")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  form_id     :integer
#

require "test_helper"

module Wf
  class EntryTest < ActiveSupport::TestCase
    test "payload defaults to empty hash" do
      user = create_user
      flow = create_case_with_workitem
      form = create_form
      entry = Wf::Entry.new(form: form, workitem: flow[:workitem], user: user)

      assert_equal({}, entry.payload)
    end

    test "json and payload include casted field values" do
      user = create_user
      flow = create_case_with_workitem
      form = create_form
      field = form.fields.create!(name: unique_name("score"), field_type: :integer)
      entry = Wf::Entry.create!(form: form, workitem: flow[:workitem], user: user)
      Wf::FieldValue.create!(form: form, field: field, entry: entry, value: "12")

      assert_equal 12, entry.json[field.id][:value]
      assert_equal({ field.name => 12 }, entry.for_mini_racer)

      entry.update_payload!

      assert_equal 12, entry.reload.payload[field.id.to_s]["value"]
    end
  end
end
