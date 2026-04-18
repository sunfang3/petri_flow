# frozen_string_literal: true

require "test_helper"

module Wf
  class FieldsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "create field with valid params" do
      form = create_form

      assert_difference("Wf::Field.count", 1) do
        post form_fields_path(form), params: {
          field: {
            name: unique_name("field"),
            field_type: :integer,
            position: 1,
            default_value: "7"
          }
        }
      end

      assert_redirected_to form_path(form)
    end

    test "update field changes attributes" do
      form = create_form
      field = form.fields.create!(name: unique_name("field"), field_type: :string)

      put form_field_path(form, field), params: {
        field: {
          name: "updated-field",
          field_type: :text
        }
      }

      assert_redirected_to form_path(form)
      assert_equal "updated-field", field.reload.name
      assert_equal "text", field.field_type
    end
  end
end
