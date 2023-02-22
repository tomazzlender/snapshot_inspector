require "test_helper"

class SnapshotInspector::Snapshot::RspecContextTest < ActiveSupport::TestCase
  test "#to_slug" do
    assert_equal "spec/requests/pages_controller_spec_5_0", rspec_context("example_without_description").to_slug
    assert_equal "spec/requests/pages_controller_spec_4_0", rspec_context("example_with_two_levels").to_slug
    assert_equal "spec/requests/pages_controller_spec_5_0", rspec_context("example_with_three_levels").to_slug
    assert_equal "spec/requests/pages_controller_spec_6_0", rspec_context("example_with_four_levels").to_slug
  end

  test "#name" do
    assert_equal "without an example description", rspec_context("example_without_description").name
    assert_equal "succeeds", rspec_context("example_with_two_levels").name
    assert_equal "when condition succeeds", rspec_context("example_with_three_levels").name
    assert_equal "root page when all is good succeeds", rspec_context("example_with_four_levels").name
  end

  test "#test_group" do
    assert_equal "PagesController", rspec_context("example_without_description").test_group
    assert_equal "PagesController", rspec_context("example_with_two_levels").test_group
    assert_equal "PagesController", rspec_context("example_with_three_levels").test_group
    assert_equal "PagesController", rspec_context("example_with_four_levels").test_group
  end

  private

  def rspec_context(name)
    SnapshotInspector::Snapshot::RspecContext.extract({
      test_framework: :rspec,
      example: JSON.parse(File.read(file_fixture("rspec_examples/#{name}.json").to_s), symbolize_names: true),
      take_snapshot_index: 0
    })
  end
end
