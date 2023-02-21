require "test_helper"

module ViewInspector
  class Snapshots::ResponseControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Test::Helpers

    setup do
      ViewInspector::Storage.clear
    end

    teardown do
      ViewInspector::Storage.clear
    end

    test "shows a response snapshot" do
      destination = ViewInspector::Storage.snapshots_directory.join("view_inspector/snapshots_controller_test/")
      destination.mkpath
      FileUtils.copy(file_fixture("test_some_controller_action_0.json"), destination)

      get response_snapshot_url("view_inspector/snapshots_controller_test/test_some_controller_action_0")

      assert_response :success
    end

    test "shows a raw response snapshot" do
      destination = ViewInspector::Storage.snapshots_directory.join("view_inspector/snapshots_controller_test/")
      destination.mkpath
      FileUtils.copy(file_fixture("test_some_controller_action_0.json"), destination)

      get raw_response_snapshot_url("view_inspector/snapshots_controller_test/test_some_controller_action_0")

      assert_response :success
    end

    test "should return not found for a show action for an unknown slug" do
      get response_snapshot_url("unknown/slug_0")

      assert_response :not_found
      assert_select "h1", text: "Not Found"
      assert_select "a", href: "/rails/snapshots"
    end

    test "returns not found for a raw action for an unknown slug" do
      get raw_response_snapshot_url("unknown/slug_0")

      assert_response :not_found
      assert_select "h1", text: "Not Found"
      assert_select "a", href: "/rails/snapshots"
    end
  end
end
