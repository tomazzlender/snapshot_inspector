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
      assert_select "li", text: /Should get index/
    end
  end
end
