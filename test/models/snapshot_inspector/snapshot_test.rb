require "test_helper"
require "snapshot_inspector/snapshot/response_type"

class SnapshotInspector::SnapshotTest < ActiveSupport::TestCase
  teardown do
    SnapshotInspector::Storage.clear
  end

  test "::persist" do
    response = ActionDispatch::TestResponse.new

    test_unit_context = {
      test_framework: :test_unit,
      method_name: "test_some_controller_action",
      source_location: ["/Users/Nickname/Code/app_name/test/controllers/some_controller_test.rb", 8],
      test_case_name: "SnapshotInspector::SnapshotsControllerTest",
      take_snapshot_index: 0
    }

    snapshot =
      travel_to(Time.zone.parse("2023-02-07 11:05:05 UTC")) do
        Rails.stub(:root, Pathname.new("/Users/Nickname/Code/app_name")) do
          response.stub(:parsed_body, "<!DOCTYPE html>\n<html>\n<head>\n  <title>View Inspector</title>\n  \n  \n\n</head>\n<body>\n\n<h1>Snapshots</h1>\n\n<ul>\n</ul>\n\n\n</body>\n</html>\n") do
            SnapshotInspector::Snapshot.persist(snapshotee: response, context: test_unit_context)
          end
        end
      end

    expected_file_contents = File.read(file_fixture("some_controller_test_8_0.json"))[0..-2]

    persisted_file_contents = File.read(SnapshotInspector::Storage.processing_directory.join("test/controllers/some_controller_test_8_0.json"))

    assert_kind_of SnapshotInspector::Snapshot, snapshot
    assert_equal expected_file_contents, persisted_file_contents
    assert_equal snapshot.slug, "test/controllers/some_controller_test_8_0"
    assert_equal snapshot.created_at, Time.zone.parse("2023-02-07 11:05:05 UTC")
    assert_equal snapshot.snapshotee_class, ActionDispatch::TestResponse
    assert_equal snapshot.context.test_framework, :test_unit
    assert_equal snapshot.context.name, "some controller action"
    assert_equal snapshot.context.method_name, "test_some_controller_action"
    assert_equal snapshot.context.source_location, ["/Users/Nickname/Code/app_name/test/controllers/some_controller_test.rb", 8]
    assert_equal snapshot.context.test_case_name, "SnapshotInspector::SnapshotsControllerTest"
    assert_equal snapshot.context.take_snapshot_index, 0
    assert_equal snapshot.body, "<!DOCTYPE html>\n<html>\n<head>\n  <title>View Inspector</title>\n  \n  \n\n</head>\n<body>\n\n<h1>Snapshots</h1>\n\n<ul>\n</ul>\n\n\n</body>\n</html>\n"
  end

  test "::find" do
    destination = SnapshotInspector::Storage.snapshots_directory.join("test/controllers/")
    destination.mkpath
    FileUtils.copy(file_fixture("some_controller_test_8_0.json"), destination)

    snapshot = SnapshotInspector::Snapshot.find("test/controllers/some_controller_test_8_0")

    assert_kind_of SnapshotInspector::Snapshot, snapshot
    assert_equal snapshot.slug, "test/controllers/some_controller_test_8_0"
    assert_equal snapshot.created_at, Time.zone.parse("2023-02-07 11:05:05 UTC")
    assert_equal snapshot.snapshotee_class, ActionDispatch::TestResponse
    assert_equal snapshot.context.test_framework, :test_unit
    assert_equal snapshot.context.name, "some controller action"
    assert_equal snapshot.context.method_name, "test_some_controller_action"
    assert_equal snapshot.context.source_location, ["/Users/Nickname/Code/app_name/test/controllers/some_controller_test.rb", 8]
    assert_equal snapshot.context.test_case_name, "SnapshotInspector::SnapshotsControllerTest"
    assert_equal snapshot.context.take_snapshot_index, 0
    assert_equal snapshot.body, "<!DOCTYPE html>\n<html>\n<head>\n  <title>View Inspector</title>\n  \n  \n\n</head>\n<body>\n\n<h1>Snapshots</h1>\n\n<ul>\n</ul>\n\n\n</body>\n</html>\n"
  end

  test "::grouped_by_test_case" do
    destination = SnapshotInspector::Storage.snapshots_directory.join("test/controllers/")
    destination.mkpath
    FileUtils.copy(file_fixture("some_controller_test_8_0.json"), destination)

    snapshots_grouped_by_test_case = SnapshotInspector::Snapshot.grouped_by_test_case

    assert_kind_of SnapshotInspector::Snapshot, snapshots_grouped_by_test_case["SnapshotInspector::SnapshotsControllerTest"].first
    assert snapshots_grouped_by_test_case.count == 1
    assert snapshots_grouped_by_test_case["SnapshotInspector::SnapshotsControllerTest"].count == 1
  end

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
      SnapshotInspector::Snapshot
        .send(:order_by_line_number, dummy_snapshots)
        .map { |snapshot| snapshot.slug }

    assert_equal expected, actual
  end

  test "raises an error when tries to persist a response that is not of kind active dispatch test response" do
    error = assert_raises(SnapshotInspector::Snapshot::UnknownSnapshotee) do
      SnapshotInspector::Snapshot.persist(snapshotee: :foo, context: {})
    end

    expected_message = "#take_snapshot only accepts an argument of kind `ActionDispatch::TestResponse` or `ActionMailer::MessageDelivery`. You provided `Symbol`."
    assert_equal expected_message, error.message
  end

  private

  def sample_snapshot_with(name, source_location, index)
    snapshotee = ActionDispatch::TestResponse.from_response(Struct.new(:body, :status, :headers).new(body: "", status: 200, headers: {}))
    SnapshotInspector::Snapshot.new.extract(
      snapshotee: snapshotee,
      context: {
        test_framework: :test_unit,
        source_location: source_location,
        test_case_name: "SomethingController",
        method_name: name,
        take_snapshot_index: index
      }
    )
  end
end
