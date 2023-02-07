require "test_helper"

class Minitest::Snapshot::SnapshotTest < ActiveSupport::TestCase
  test "#order_by_line_numbers" do
    expected = [
      {source_location: ["/test/controllers/another_dummy_controller.rb", 9]},
      {source_location: ["/test/controllers/another_dummy_controller.rb", 30]},
      {source_location: ["/test/controllers/dummy_controller.rb", 10]},
      {source_location: ["/test/controllers/dummy_controller.rb", 13]},
      {source_location: ["/test/controllers/dummy_controller.rb", 21]}
    ]

    dummy_snapshots = [
      {source_location: ["/test/controllers/dummy_controller.rb", 21]},
      {source_location: ["/test/controllers/another_dummy_controller.rb", 30]},
      {source_location: ["/test/controllers/dummy_controller.rb", 10]},
      {source_location: ["/test/controllers/another_dummy_controller.rb", 9]},
      {source_location: ["/test/controllers/dummy_controller.rb", 13]}
    ]
    actual = Minitest::Snapshot::Snapshot.send(:order_by_line_number, dummy_snapshots)

    assert_equal expected, actual
  end
end
