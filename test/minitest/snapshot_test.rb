require "test_helper"

class Minitest::SnapshotTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Minitest::Snapshot::VERSION
  end
end
