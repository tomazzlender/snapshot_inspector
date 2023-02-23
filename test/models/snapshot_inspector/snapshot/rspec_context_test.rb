require "test_helper"

class SnapshotInspector::Snapshot::RspecContextTest < ActiveSupport::TestCase
  test "::extract" do
    assert_kind_of SnapshotInspector::Snapshot::Context, rspec_context("example_with_two_levels")
    assert_equal :rspec, rspec_context("example_with_two_levels").test_framework
    assert_includes rspec_context("example_with_two_levels").example, :example_group
    assert_equal 0, rspec_context("example_with_two_levels").take_snapshot_index
  end

  test "::from_hash" do
    hash = JSON.parse(rspec_context("example_with_two_levels").to_json, symbolize_names: true)
    rspec_context = SnapshotInspector::Snapshot::Context.from_hash(hash)

    assert_kind_of SnapshotInspector::Snapshot::Context, rspec_context
    assert_equal :rspec, rspec_context.test_framework
    assert_includes rspec_context.example, :example_group
    assert_equal 0, rspec_context.take_snapshot_index
  end

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

  test "#order_index" do
    assert_equal ["./spec/requests/pages_controller_spec.rb", 5, 0], rspec_context("example_without_description").order_index
    assert_equal ["./spec/requests/pages_controller_spec.rb", 4, 0], rspec_context("example_with_two_levels").order_index
    assert_equal ["./spec/requests/pages_controller_spec.rb", 5, 0], rspec_context("example_with_three_levels").order_index
    assert_equal ["./spec/requests/pages_controller_spec.rb", 6, 0], rspec_context("example_with_four_levels").order_index
  end

  private

  def rspec_context(name)
    SnapshotInspector::Snapshot::Context.extract({
      test_framework: :rspec,
      example: JSON.parse(File.read(file_fixture("rspec_examples/#{name}.json").to_s), symbolize_names: true),
      take_snapshot_index: 0
    })
  end
end
