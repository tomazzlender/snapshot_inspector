require "test_helper"

module ViewInspector
  class Snapshots::MailControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Test::Helpers

    setup do
      ViewInspector::Storage.clear
    end

    teardown do
      ViewInspector::Storage.clear
    end

    test "shows a mail snapshot" do
      destination = ViewInspector::Storage.snapshots_directory.join("user_mailer_test")
      destination.mkpath
      FileUtils.copy(file_fixture("user_mailer_test/test_welcome_0.json"), destination)

      get mail_snapshot_url("user_mailer_test/test_welcome_0")

      assert_response :success
    end

    test "shows a raw mail snapshot" do
      destination = ViewInspector::Storage.snapshots_directory.join("user_mailer_test")
      destination.mkpath
      FileUtils.copy(file_fixture("user_mailer_test/test_welcome_0.json"), destination)

      get raw_mail_snapshot_url("user_mailer_test/test_welcome_0")

      assert_response :success
    end

    test "should return not found for a show action for an unknown slug" do
      get mail_snapshot_url("unknown/slug_0")

      assert_response :not_found
      assert_select "h1", text: "Not Found"
      assert_select "a", href: "/rails/snapshots"
    end

    test "returns not found for a raw action for an unknown slug" do
      get raw_mail_snapshot_url("unknown/slug_0")

      assert_response :not_found
      assert_select "h1", text: "Not Found"
      assert_select "a", href: "/rails/snapshots"
    end
  end
end
