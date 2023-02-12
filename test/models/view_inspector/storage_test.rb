require "test_helper"

class ViewInspector::StorageTest < ActiveSupport::TestCase
  DUMMY_DIRECTORY = Rails.root.join("tmp/dummy").freeze

  setup { DUMMY_DIRECTORY.rmtree }
  teardown { DUMMY_DIRECTORY.rmtree }

  test "::write, ::read, ::list" do
    ViewInspector.configuration.stub(:storage_directory, DUMMY_DIRECTORY) do
      value1, value2 = '{"foo": "bar"}', '{"foo": "baz"}'
      ViewInspector::Storage.write("namespace/key1", value1)
      ViewInspector::Storage.write("namespace/key2", value2)
      ViewInspector::Storage.move_files_from_processing_directory_to_snapshots_directory

      assert_equal value1, File.read(ViewInspector::Storage.snapshots_directory.join("namespace/key1.json"))
      assert_equal value1, ViewInspector::Storage.read("namespace/key1")
      assert_equal %w[namespace/key1 namespace/key2], ViewInspector::Storage.list
    end
  end
end
