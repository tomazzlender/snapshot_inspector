require "test_helper"

module Minitest::Snapshot
  class SnapshotsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Test::IntegrationHelpers

    setup do
      Rails.root.join("tmp", "snapshots").rmtree
    end

    test "should get index" do
      destination = Rails.root.join("tmp/snapshots/minitest/snapshot/snapshots_controller_test/")
      destination.mkpath
      FileUtils.copy(file_fixture("test_should_get_index.json"), destination)

      get root_path

      assert_response :success
      assert_select "h1", text: "Snapshots"
      assert_select "li", text: /should get index/
      assert_select "[data-label='snapshot.source_location']", text: "/Users/Nickname/Code/app_name/test/controllers/some_controller_test.rb:42"
    end

    test "should get show" do
      destination = Rails.root.join("tmp/snapshots/minitest/snapshot/snapshots_controller_test/")
      destination.mkpath
      FileUtils.copy(file_fixture("test_should_get_index.json"), destination)

      get snapshot_url("minitest/snapshot/snapshots_controller_test/test_should_get_index/0")

      assert_response :success
    end
  end
end
