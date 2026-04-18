# frozen_string_literal: true

require "test_helper"

module Wf
  class PlacesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "create place with valid params" do
      workflow = create_workflow

      assert_difference("Wf::Place.count", 1) do
        post workflow_places_path(workflow), params: {
          place: {
            name: unique_name("place"),
            description: "from controller test",
            place_type: :normal
          }
        }
      end

      assert_redirected_to workflow_path(workflow)
    end

    test "update place changes attributes" do
      workflow = create_workflow
      place = workflow.places.create!(name: unique_name("place"), place_type: :normal)

      put workflow_place_path(workflow, place), params: {
        place: {
          name: "updated-place",
          description: "updated"
        }
      }

      assert_redirected_to workflow_path(workflow)
      assert_equal "updated-place", place.reload.name
      assert_equal "updated", place.description
    end
  end
end
