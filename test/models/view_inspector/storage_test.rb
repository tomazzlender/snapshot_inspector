require "test_helper"

class ViewInspector::StorageTest < ActiveSupport::TestCase
  DUMMY_STORAGE_PATH = Rails.root.join("tmp/dummy_storage").freeze

  setup { DUMMY_STORAGE_PATH.rmtree }
  teardown { DUMMY_STORAGE_PATH.rmtree }

  test "::write, ::read, ::list" do
    ViewInspector.configuration.stub(:absolute_storage_directory, DUMMY_STORAGE_PATH) do
      value1, value2 = '{"foo": "bar"}', '{"foo": "baz"}'
      ViewInspector::Storage.write("namespace/key1", value1)
      ViewInspector::Storage.write("namespace/key2", value2)

      assert_equal value1, File.read(DUMMY_STORAGE_PATH.join("namespace/key1.json"))
      assert_equal value1, ViewInspector::Storage.read("namespace/key1")
      assert_equal %w[namespace/key1 namespace/key2], ViewInspector::Storage.list
    end
  end
end
