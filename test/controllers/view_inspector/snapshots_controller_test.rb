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

    test "should show a snapshot with a response" do
      destination = ViewInspector::Storage.snapshots_directory.join("view_inspector/snapshots_controller_test/")
      destination.mkpath
      FileUtils.copy(file_fixture("test_some_controller_action_0.json"), destination)

      get response_snapshot_url("view_inspector/snapshots_controller_test/test_some_controller_action_0")

      assert_response :success
    end

    test "should show a raw response" do
      destination = ViewInspector::Storage.snapshots_directory.join("view_inspector/snapshots_controller_test/")
      destination.mkpath
      FileUtils.copy(file_fixture("test_some_controller_action_0.json"), destination)

      get raw_response_snapshot_url("view_inspector/snapshots_controller_test/test_some_controller_action_0")

      assert_response :success
    end

    test "should show a snapshot with a mail" do
      destination = ViewInspector::Storage.snapshots_directory.join("user_mailer_test")
      destination.mkpath
      FileUtils.copy(file_fixture("user_mailer_test/test_welcome_0.json"), destination)

      get mail_snapshot_url("user_mailer_test/test_welcome_0")

      assert_response :success
    end

    test "should show a raw mail" do
      destination = ViewInspector::Storage.snapshots_directory.join("user_mailer_test")
      destination.mkpath
      FileUtils.copy(file_fixture("user_mailer_test/test_welcome_0.json"), destination)

      get raw_mail_snapshot_url("user_mailer_test/test_welcome_0")

      assert_response :success
    end

    test "should return not found for a unknown slug" do
      get response_snapshot_url("raw/unknown/slug/0")

      assert_response :not_found
      assert_select "h1", text: "Not Found"
      assert_select "a", href: "/rails/snapshots"
    end
  end
end
