require "test_helper"

module ViewInspector
  class SnapshotsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Test::Helpers

    setup do
      ViewInspector::Storage.clear
    end

    teardown do
      ViewInspector::Storage.clear
    end

    test "should a list of snapshots grouped by test cases" do
      destination = ViewInspector::Storage.snapshots_directory.join("view_inspector/snapshots_controller_test/")
      destination.mkpath
      FileUtils.copy(file_fixture("test_some_controller_action_0.json"), destination)

      get root_path

      assert_response :success
      assert_select "h1", text: "Snapshots"
      assert_select "li", text: /some controller action/
    end
  end
end
