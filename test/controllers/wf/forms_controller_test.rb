# frozen_string_literal: true

require "test_helper"

module Wf
  class FormsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "index is reachable" do
      get forms_path

      assert_response :success
    end

    test "create and destroy form" do
      assert_difference("Wf::Form.count", 1) do
        post forms_path, params: {
          form: {
            name: unique_name("form"),
            description: "created by controller test"
          }
        }
      end
      assert_redirected_to forms_path

      form = Wf::Form.order(:id).last

      assert_difference("Wf::Form.count", -1) do
        delete form_path(form)
      end
      assert_redirected_to forms_path
    end
  end
end
