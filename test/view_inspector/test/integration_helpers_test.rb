require "test_helper"

class DummyControllerTest < ActiveSupport::TestCase
  include ViewInspector::Test::Helpers

  test "some controller action" do
  end
end

class ViewInspector::Test::IntegrationHelpersTest < ActiveSupport::TestCase
  include EnvironmentHelper

  setup do
    ViewInspector::Storage.clear
  end

  test "#take_snapshot called once" do
    test_case_example = DummyControllerTest.new("test_some_controller_action")
    response = ActionDispatch::TestResponse.new

    travel_to(Time.new(2023, 2, 7, 12, 5, 5)) do
      ViewInspector.configuration.stub(:snapshot_taking_enabled, true) do
        response.stub(:parsed_body, "<html><body>Example response body.</body></html>") do
          test_case_example.take_snapshot(response)
        end
      end
    end

    expected_contents = {
      response_recording: {
        body: "<html><body>Example response body.</body></html>"
      },
      test_recording: {
        name: "some controller action",
        method_name: "test_some_controller_action",
        source_location: [
          "#{ViewInspector::Engine.root}/test/view_inspector/test/integration_helpers_test.rb",
          6
        ],
        test_case_name: "DummyControllerTest",
        take_snapshot_index: 0,
        test_case_file_path: "#{ViewInspector::Engine.root}/test/view_inspector/test/integration_helpers_test.rb",
        line_number: 6
      },
      created_at: "2023-02-07T11:05:05.000Z",
      slug: "dummy_controller_test/test_some_controller_action_0"
    }

    snapshot_file_path = ViewInspector::Storage.processing_directory.join("dummy_controller_test", "test_some_controller_action_0.json")
    assert_equal JSON.pretty_generate(expected_contents), File.read(snapshot_file_path)
  end

  test "#take_snapshot called twice" do
    test_case_example = DummyControllerTest.new("test_some_controller_action")
    first_response = ActionDispatch::TestResponse.new
    second_response = ActionDispatch::TestResponse.new

    travel_to(Time.new(2023, 2, 7, 12, 5, 5)) do
      ViewInspector.configuration.stub(:snapshot_taking_enabled, true) do
        first_response.stub(:parsed_body, "<html><body>Example response body.</body></html>") do
          test_case_example.take_snapshot(first_response)

          second_response.stub(:parsed_body, "<html><body>Another response body.</body></html>") do
            test_case_example.take_snapshot(second_response)
          end
        end
      end
    end

    snapshot1_expected_contents = {
      response_recording: {
        body: "<html><body>Example response body.</body></html>"
      },
      test_recording: {
        name: "some controller action",
        method_name: "test_some_controller_action",
        source_location: [
          "#{ViewInspector::Engine.root}/test/view_inspector/test/integration_helpers_test.rb",
          6
        ],
        test_case_name: "DummyControllerTest",
        take_snapshot_index: 0,
        test_case_file_path: "#{ViewInspector::Engine.root}/test/view_inspector/test/integration_helpers_test.rb",
        line_number: 6
      },
      created_at: "2023-02-07T11:05:05.000Z",
      slug: "dummy_controller_test/test_some_controller_action_0"
    }

    snapshot2_expected_contents = {
      response_recording: {
        body: "<html><body>Another response body.</body></html>"
      },
      test_recording: {
        name: "some controller action",
        method_name: "test_some_controller_action",
        source_location: [
          "#{ViewInspector::Engine.root}/test/view_inspector/test/integration_helpers_test.rb",
          6
        ],
        test_case_name: "DummyControllerTest",
        take_snapshot_index: 1,
        test_case_file_path: "#{ViewInspector::Engine.root}/test/view_inspector/test/integration_helpers_test.rb",
        line_number: 6
      },
      created_at: "2023-02-07T11:05:05.000Z",
      slug: "dummy_controller_test/test_some_controller_action_1"
    }

    snapshot1_file_path = ViewInspector::Storage.processing_directory.join("dummy_controller_test", "test_some_controller_action_0.json")
    assert_equal JSON.pretty_generate(snapshot1_expected_contents), File.read(snapshot1_file_path)

    snapshot2_file_path = ViewInspector::Storage.processing_directory.join("dummy_controller_test", "test_some_controller_action_1.json")
    assert_equal JSON.pretty_generate(snapshot2_expected_contents), File.read(snapshot2_file_path)
  end
end
