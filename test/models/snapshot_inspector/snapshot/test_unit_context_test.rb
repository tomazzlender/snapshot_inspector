require "test_helper"

class SnapshotInspector::Snapshot::TestUnitContextTest < ActiveSupport::TestCase
  test "::extract" do
    assert_kind_of SnapshotInspector::Snapshot::TestUnitContext, test_unit_context
    assert_equal :test_unit, test_unit_context.test_framework
    assert_equal "test_some_controller_action", test_unit_context.method_name
    assert_equal ["/Users/Nickname/Code/app_name/test/controllers/some_controller_test.rb", 8], test_unit_context.source_location
    assert_equal "SnapshotInspector::SnapshotsControllerTest", test_unit_context.test_case_name
    assert_equal 0, test_unit_context.take_snapshot_index
  end

  test "::from_hash" do
    hash = JSON.parse(test_unit_context.to_json, symbolize_names: true)
    test_unit_context_from_hash = SnapshotInspector::Snapshot::TestUnitContext.from_hash(hash)

    assert_kind_of SnapshotInspector::Snapshot::TestUnitContext, test_unit_context
    assert_equal :test_unit, test_unit_context.test_framework
    assert_equal "test_some_controller_action", test_unit_context_from_hash.method_name
    assert_equal ["/Users/Nickname/Code/app_name/test/controllers/some_controller_test.rb", 8], test_unit_context_from_hash.source_location
    assert_equal "SnapshotInspector::SnapshotsControllerTest", test_unit_context_from_hash.test_case_name
    assert_equal 0, test_unit_context_from_hash.take_snapshot_index
  end

  test "#to_slug" do
    Rails.stub(:root, Pathname.new("/Users/Nickname/Code/app_name")) do
      assert_equal "test/controllers/some_controller_test_8_0", test_unit_context.to_slug
    end
  end

  test "#name" do
    assert_equal "some controller action", test_unit_context.name
  end

  test "#test_group" do
    assert_equal "SnapshotInspector::SnapshotsControllerTest", test_unit_context.test_group
  end

  test "#order_index" do
    assert_equal ["/Users/Nickname/Code/app_name/test/controllers/some_controller_test.rb", 8, 0], test_unit_context.order_index
  end

  private

  def test_unit_context
    SnapshotInspector::Snapshot::TestUnitContext.extract(
      {
        test_framework: :test_unit,
        method_name: "test_some_controller_action",
        source_location: ["/Users/Nickname/Code/app_name/test/controllers/some_controller_test.rb", 8],
        test_case_name: "SnapshotInspector::SnapshotsControllerTest",
        take_snapshot_index: 0
      }
    )
  end
end
