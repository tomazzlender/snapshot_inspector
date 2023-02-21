require "test_helper"

class SnapshotInspector::StorageTest < ActiveSupport::TestCase
  DUMMY_DIRECTORY = Rails.root.join("tmp/dummy").freeze

  setup { DUMMY_DIRECTORY.rmtree }
  teardown { DUMMY_DIRECTORY.rmtree }

  test "::write, ::read, ::list" do
    SnapshotInspector.configuration.stub(:storage_directory, DUMMY_DIRECTORY) do
      value1, value2 = '{"foo": "bar"}', '{"foo": "baz"}'
      SnapshotInspector::Storage.write("namespace/key1", value1)
      SnapshotInspector::Storage.write("namespace/key2", value2)
      SnapshotInspector::Storage.move_files_from_processing_directory_to_snapshots_directory

      assert_equal value1, File.read(SnapshotInspector::Storage.snapshots_directory.join("namespace/key1.json"))
      assert_equal value1, SnapshotInspector::Storage.read("namespace/key1")
      assert_equal %w[namespace/key1 namespace/key2], SnapshotInspector::Storage.list
    end
  end
end
