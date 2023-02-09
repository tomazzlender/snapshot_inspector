require "test_helper"

class Minitest::Snapshot::SnapshotTest < ActiveSupport::TestCase
  test "private #order_by_line_numbers" do
    expected = [
      sample_snapshot_with("test_example_something", ["/test/controllers/another_dummy_controller.rb", 9], 0),
      sample_snapshot_with("test_example_another", ["/test/controllers/another_dummy_controller.rb", 30], 0),
      sample_snapshot_with("test_example_one", ["/test/controllers/dummy_controller.rb", 10], 0),
      sample_snapshot_with("test_example_one", ["/test/controllers/dummy_controller.rb", 13], 1),
      sample_snapshot_with("test_example_else", ["/test/controllers/dummy_controller.rb", 21], 0)
    ].map { |snapshot| snapshot.slug }

    dummy_snapshots = [
      sample_snapshot_with("test_example_else", ["/test/controllers/dummy_controller.rb", 21], 0),
      sample_snapshot_with("test_example_another", ["/test/controllers/another_dummy_controller.rb", 30], 0),
      sample_snapshot_with("test_example_one", ["/test/controllers/dummy_controller.rb", 10], 0),
      sample_snapshot_with("test_example_something", ["/test/controllers/another_dummy_controller.rb", 9], 0),
      sample_snapshot_with("test_example_one", ["/test/controllers/dummy_controller.rb", 13], 1)
    ]

    actual =
      Minitest::Snapshot::Snapshot
        .send(:order_by_line_number, dummy_snapshots)
        .map { |snapshot| snapshot.slug }

    assert_equal expected, actual
  end

  private

  def sample_snapshot_with(name, source_location, index)
    Minitest::Snapshot::Snapshot.new.parse(
      response: Struct.new(:parsed_body).new(parsed_body: ""),
      test: {
        source_location: source_location,
        test_case_name: "SomethingController",
        method_name: name,
        take_snapshot_index: index
      }
    )
  end
end
