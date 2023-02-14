require "test_helper"

class ViewInspector::SnapshotTest < ActiveSupport::TestCase
  test "::persist" do
    response = ActionDispatch::TestResponse.new

    test = {
      method_name: "test_some_controller_action",
      source_location: ["/Users/Nickname/Code/app_name/test/controllers/some_controller_test.rb", 6],
      test_case_name: "ViewInspector::SnapshotsControllerTest",
      take_snapshot_index: 0
    }

    snapshot =
      travel_to(Time.zone.parse("2023-02-07 11:05:05 UTC")) do
        response.stub(:parsed_body, "<!DOCTYPE html>\n<html>\n<head>\n  <title>View Inspector</title>\n  \n  \n\n</head>\n<body>\n\n<h1>Snapshots</h1>\n\n<ul>\n</ul>\n\n\n</body>\n</html>\n") do
          ViewInspector::Snapshot.persist(snapshotee: response, test: test)
        end
      end

    expected_file_contents = File.read(file_fixture("test_some_controller_action_0.json"))[0..-2]
    persisted_file_contents = File.read(ViewInspector::Storage.processing_directory.join("view_inspector/snapshots_controller_test/test_some_controller_action_0.json"))

    assert_kind_of ViewInspector::Snapshot, snapshot
    assert_equal expected_file_contents, persisted_file_contents
    assert_equal snapshot.slug, "view_inspector/snapshots_controller_test/test_some_controller_action_0"
    assert_equal snapshot.created_at, Time.zone.parse("2023-02-07 11:05:05 UTC")
    assert_equal snapshot.test_recording.name, "some controller action"
    assert_equal snapshot.test_recording.method_name, "test_some_controller_action"
    assert_equal snapshot.test_recording.source_location, ["/Users/Nickname/Code/app_name/test/controllers/some_controller_test.rb", 6]
    assert_equal snapshot.test_recording.test_case_name, "ViewInspector::SnapshotsControllerTest"
    assert_equal snapshot.test_recording.take_snapshot_index, 0
    assert_equal snapshot.test_recording.test_case_file_path, "/Users/Nickname/Code/app_name/test/controllers/some_controller_test.rb"
    assert_equal snapshot.test_recording.line_number, 6
    assert_equal snapshot.response_recording.body, "<!DOCTYPE html>\n<html>\n<head>\n  <title>View Inspector</title>\n  \n  \n\n</head>\n<body>\n\n<h1>Snapshots</h1>\n\n<ul>\n</ul>\n\n\n</body>\n</html>\n"
  end

  test "::find" do
    destination = ViewInspector::Storage.snapshots_directory.join("view_inspector/snapshots_controller_test/")
    destination.mkpath
    FileUtils.copy(file_fixture("test_some_controller_action_0.json"), destination)

    snapshot = ViewInspector::Snapshot.find("view_inspector/snapshots_controller_test/test_some_controller_action_0")

    assert_kind_of ViewInspector::Snapshot, snapshot
    assert_equal snapshot.slug, "view_inspector/snapshots_controller_test/test_some_controller_action_0"
    assert_equal snapshot.created_at, Time.zone.parse("2023-02-07 11:05:05 UTC")
    assert_equal snapshot.test_recording.name, "some controller action"
    assert_equal snapshot.test_recording.method_name, "test_some_controller_action"
    assert_equal snapshot.test_recording.source_location, ["/Users/Nickname/Code/app_name/test/controllers/some_controller_test.rb", 6]
    assert_equal snapshot.test_recording.test_case_name, "ViewInspector::SnapshotsControllerTest"
    assert_equal snapshot.test_recording.take_snapshot_index, 0
    assert_equal snapshot.test_recording.test_case_file_path, "/Users/Nickname/Code/app_name/test/controllers/some_controller_test.rb"
    assert_equal snapshot.test_recording.line_number, 6
    assert_equal snapshot.response_recording.body, "<!DOCTYPE html>\n<html>\n<head>\n  <title>View Inspector</title>\n  \n  \n\n</head>\n<body>\n\n<h1>Snapshots</h1>\n\n<ul>\n</ul>\n\n\n</body>\n</html>\n"
  end

  test "::grouped_by_test_case" do
    destination = ViewInspector::Storage.snapshots_directory.join("view_inspector/snapshots_controller_test/")
    destination.mkpath
    FileUtils.copy(file_fixture("test_some_controller_action_0.json"), destination)

    snapshots_grouped_by_test_case = ViewInspector::Snapshot.grouped_by_test_case

    assert_kind_of ViewInspector::Snapshot, snapshots_grouped_by_test_case["ViewInspector::SnapshotsControllerTest"].first
    assert snapshots_grouped_by_test_case.count == 1
    assert snapshots_grouped_by_test_case["ViewInspector::SnapshotsControllerTest"].count == 1
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
      ViewInspector::Snapshot
        .send(:order_by_line_number, dummy_snapshots)
        .map { |snapshot| snapshot.slug }

    assert_equal expected, actual
  end

  test "raises an error when tries to persist a response that is not of kind active dispatch test response" do
    error = assert_raises(ViewInspector::Snapshot::InvalidInput) do
      ViewInspector::Snapshot.persist(snapshotee: :foo, test: {})
    end

    expected_message = "#take_snapshot only accepts an argument of kind `ActionDispatch::TestResponse`. You provided `Symbol`."
    assert_equal expected_message, error.message
  end

  private

  def sample_snapshot_with(name, source_location, index)
    ViewInspector::Snapshot.new.parse(
      snapshotee: Struct.new(:parsed_body).new(parsed_body: ""),
      test: {
        source_location: source_location,
        test_case_name: "SomethingController",
        method_name: name,
        take_snapshot_index: index
      }
    )
  end
end
