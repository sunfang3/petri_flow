# frozen_string_literal: true

require "test_helper"

class NavigationTest < ActionDispatch::IntegrationTest
  include Wf::Engine.routes.url_helpers

  test "engine root loads workitems page" do
    get root_path

    assert_response :success
    assert_includes response.body, "Workitems"
  end
end
