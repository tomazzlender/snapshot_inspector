require "test_helper"

module ViewInspector
  class SnapshotsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Test::IntegrationHelpers

    setup do
      ViewInspector::Cleaner.clean_snapshots_from_previous_run
    end

    test "should get index" do
      destination = ViewInspector.configuration.storage_directory.join("view_inspector/snapshots_controller_test/")
      destination.mkpath
      FileUtils.copy(file_fixture("test_some_controller_action_0.json"), destination)

      get root_path

      assert_response :success
      assert_select "h1", text: "Snapshots"
      assert_select "li", text: /some controller action/
    end

    test "should get show" do
      destination = ViewInspector.configuration.storage_directory.join("view_inspector/snapshots_controller_test/")
      destination.mkpath
      FileUtils.copy(file_fixture("test_some_controller_action_0.json"), destination)

      get snapshot_url("view_inspector/snapshots_controller_test/test_some_controller_action_0")

      assert_response :success
    end

    test "should return not found for a unknown slug" do
      get snapshot_url("unknown/slug/0")

      assert_response :not_found
      assert_select "h1", text: "Not Found"
      assert_select "a", href: ViewInspector.configuration.route_path
    end
  end
end