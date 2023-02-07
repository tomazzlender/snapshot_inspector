require "test_helper"

module Minitest::Snapshot
  class SnapshotsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get root_path
      assert_response :success
    end
  end
end
