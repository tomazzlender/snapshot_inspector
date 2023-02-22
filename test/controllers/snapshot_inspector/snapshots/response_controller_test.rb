require "test_helper"

module SnapshotInspector
  class Snapshots::ResponseControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Test::TestUnitHelpers

    setup do
      SnapshotInspector::Storage.clear
    end

    teardown do
      SnapshotInspector::Storage.clear
    end

    test "shows a response snapshot" do
      destination = SnapshotInspector::Storage.snapshots_directory.join("test/controllers/")
      destination.mkpath
      FileUtils.copy(file_fixture("some_controller_test_8_0.json"), destination)

      get response_snapshot_url("test/controllers/some_controller_test_8_0")

      assert_response :success
    end

    test "shows a raw response snapshot" do
      destination = SnapshotInspector::Storage.snapshots_directory.join("test/controllers/")
      destination.mkpath
      FileUtils.copy(file_fixture("some_controller_test_8_0.json"), destination)

      get raw_response_snapshot_url("test/controllers/some_controller_test_8_0")

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
