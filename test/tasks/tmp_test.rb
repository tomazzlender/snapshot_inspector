require "test_helper"
require "view_inspector/storage"

class TmpTaskTest < ActiveSupport::TestCase
  def setup
    Rails.application.load_tasks
  end

  test "clears tmp/view_inspector/snapshots directory" do
    mock = MiniTest::Mock.new
    mock.expect(:call, nil)

    ViewInspector::Storage.stub(:clear, mock) do
      Rake::Task["tmp:snapshots:clear"].invoke
    end

    assert mock.verify
  end
end
