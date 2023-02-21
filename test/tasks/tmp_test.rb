require "test_helper"
require "snapshot_inspector/storage"

class TmpTaskTest < ActiveSupport::TestCase
  def setup
    Rails.application.load_tasks
  end

  test "clears tmp/snapshot_inspector/snapshots directory" do
    mock = MiniTest::Mock.new
    mock.expect(:call, nil)

    SnapshotInspector::Storage.stub(:clear, mock) do
      Rake::Task["tmp:snapshots:clear"].invoke
    end

    assert mock.verify
  end
end
