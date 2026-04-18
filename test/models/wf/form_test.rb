# frozen_string_literal: true

# == Schema Information
#
# Table name: wf_forms
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "test_helper"

module Wf
  class FormTest < ActiveSupport::TestCase
    test "destroy cascades to associated fields" do
      form = create_form
      form.fields.create!(name: unique_name("field"), field_type: :string)

      assert_difference("Wf::Field.count", -1) do
        form.destroy
      end
    end
  end
end
