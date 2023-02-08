require "test_helper"

class DummyControllerTest < ActiveSupport::TestCase
  include Minitest::Snapshot::Test::IntegrationHelpers

  test "some controller action" do
  end
end

class Minitest::Snapshot::Test::IntegrationHelpersTest < ActiveSupport::TestCase
  include EnvironmentHelper

  setup do
    Minitest::Snapshot::Cleaner.clean_snapshots_from_previous_run
  end

  test "#take_snapshot called once" do
    test_case_example = DummyControllerTest.new("test_some_controller_action")
    response = ActionDispatch::TestResponse.new

    travel_to(Time.new(2023, 2, 7, 12, 5, 5)) do
      Minitest::Snapshot.configuration.stub(:snapshot_taking_enabled, true) do
        response.stub(:parsed_body, "<html><body>Example response body.</body></html>") do
          test_case_example.take_snapshot(response)
        end
      end
    end

    expected_contents = [
      {
        slug: "dummy_controller_test/test_some_controller_action/0",
        created_at: "2023-02-07 11:05:05 UTC",
        response_body: "<html><body>Example response body.</body></html>",
        test_case_name: "test_some_controller_action",
        test_case_human_name: "some controller action",
        test_class: "DummyControllerTest",
        source_location: [
          "#{Minitest::Snapshot::Engine.root}/test/minitest/snapshot/test/integration_helpers_test.rb",
          6
        ]
      }
    ]

    snapshot_file_path = Minitest::Snapshot.configuration.storage_directory.join("dummy_controller_test", "test_some_controller_action.json")
    assert_equal JSON.pretty_generate(expected_contents), File.read(snapshot_file_path)
  end

  test "#take_snapshot called twice" do
    test_case_example = DummyControllerTest.new("test_some_controller_action")
    first_response = ActionDispatch::TestResponse.new
    second_response = ActionDispatch::TestResponse.new

    travel_to(Time.new(2023, 2, 7, 12, 5, 5)) do
      Minitest::Snapshot.configuration.stub(:snapshot_taking_enabled, true) do
        first_response.stub(:parsed_body, "<html><body>Example response body.</body></html>") do
          test_case_example.take_snapshot(first_response)

          second_response.stub(:parsed_body, "<html><body>Another response body.</body></html>") do
            test_case_example.take_snapshot(second_response)
          end
        end
      end
    end

    expected_contents = [
      {
        slug: "dummy_controller_test/test_some_controller_action/0",
        created_at: "2023-02-07 11:05:05 UTC",
        response_body: "<html><body>Example response body.</body></html>",
        test_case_name: "test_some_controller_action",
        test_case_human_name: "some controller action",
        test_class: "DummyControllerTest",
        source_location: [
          "#{Minitest::Snapshot::Engine.root}/test/minitest/snapshot/test/integration_helpers_test.rb",
          6
        ]
      },
      {
        slug: "dummy_controller_test/test_some_controller_action/1",
        created_at: "2023-02-07 11:05:05 UTC",
        response_body: "<html><body>Another response body.</body></html>",
        test_case_name: "test_some_controller_action",
        test_case_human_name: "some controller action",
        test_class: "DummyControllerTest",
        source_location: [
          "#{Minitest::Snapshot::Engine.root}/test/minitest/snapshot/test/integration_helpers_test.rb",
          6
        ]
      }
    ]

    snapshot_file_path = Minitest::Snapshot.configuration.storage_directory.join("dummy_controller_test", "test_some_controller_action.json")
    assert_equal JSON.pretty_generate(expected_contents), File.read(snapshot_file_path)
  end
end
