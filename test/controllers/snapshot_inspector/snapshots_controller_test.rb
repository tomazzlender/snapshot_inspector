require "test_helper"

module SnapshotInspector
  class SnapshotsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Test::TestUnitHelpers

    setup do
      SnapshotInspector::Storage.clear
    end

    teardown do
      SnapshotInspector::Storage.clear
    end

    test "should a list of snapshots grouped by test cases" do
      destination = SnapshotInspector::Storage.snapshots_directory.join("test/controllers/")
      destination.mkpath
      FileUtils.copy(file_fixture("some_controller_test_8_0.json"), destination)

      get root_path

      assert_response :success
      assert_select "h1", text: "Snapshots"
      assert_select "li", text: /some controller action/
    end
  end
end
