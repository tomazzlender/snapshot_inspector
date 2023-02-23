require "test_helper"

class DummyControllerTest < ActiveSupport::TestCase
  include SnapshotInspector::Test::TestUnitHelpers

  test "some controller action" do
  end
end

class SnapshotInspector::Test::HelpersTest < ActiveSupport::TestCase
  include EnvironmentHelper

  setup do
    SnapshotInspector::Storage.clear
  end

  test "#take_snapshot called once" do
    test_case_example = DummyControllerTest.new("test_some_controller_action")
    response = ActionDispatch::TestResponse.new

    travel_to(Time.new(2023, 2, 7, 12, 5, 5)) do
      SnapshotInspector.configuration.stub(:snapshot_taking_enabled, true) do
        Rails.stub(:root, SnapshotInspector::Engine.root) do
          response.stub(:parsed_body, "<html><body>Example response body.</body></html>") do
            test_case_example.take_snapshot(response)
          end
        end
      end
    end

    expected_contents = {
      type_data: {
        snapshotee_class: "ActionDispatch::TestResponse",
        body: "<html><body>Example response body.</body></html>"
      },
      type: "response",
      context: {
        test_framework: "test_unit",
        test_case_name: "DummyControllerTest",
        method_name: "test_some_controller_action",
        source_location: [
          "#{SnapshotInspector::Engine.root}/test/snapshot_inspector/test/test_unit_helpers_test.rb",
          6
        ],
        take_snapshot_index: 0
      },
      slug: "test/snapshot_inspector/test/test_unit_helpers_test_6_0",
      created_at: "2023-02-07T11:05:05.000Z"
    }

    snapshot_file_path = SnapshotInspector::Storage.processing_directory.join("test/snapshot_inspector/test/test_unit_helpers_test_6_0.json")
    assert_equal JSON.pretty_generate(expected_contents), File.read(snapshot_file_path)
  end

  test "#take_snapshot called twice" do
    test_case_example = DummyControllerTest.new("test_some_controller_action")
    first_response = ActionDispatch::TestResponse.new
    second_response = ActionDispatch::TestResponse.new

    travel_to(Time.new(2023, 2, 7, 12, 5, 5)) do
      SnapshotInspector.configuration.stub(:snapshot_taking_enabled, true) do
        Rails.stub(:root, SnapshotInspector::Engine.root) do
          first_response.stub(:parsed_body, "<html><body>Example response body.</body></html>") do
            test_case_example.take_snapshot(first_response)

            second_response.stub(:parsed_body, "<html><body>Another response body.</body></html>") do
              test_case_example.take_snapshot(second_response)
            end
          end
        end
      end
    end

    snapshot1_expected_contents = {
      type_data: {
        snapshotee_class: "ActionDispatch::TestResponse",
        body: "<html><body>Example response body.</body></html>"
      },
      type: "response",
      context: {
        test_framework: "test_unit",
        test_case_name: "DummyControllerTest",
        method_name: "test_some_controller_action",
        source_location: [
          "#{SnapshotInspector::Engine.root}/test/snapshot_inspector/test/test_unit_helpers_test.rb",
          6
        ],
        take_snapshot_index: 0
      },
      slug: "test/snapshot_inspector/test/test_unit_helpers_test_6_0",
      created_at: "2023-02-07T11:05:05.000Z"
    }

    snapshot2_expected_contents = {
      type_data: {
        snapshotee_class: "ActionDispatch::TestResponse",
        body: "<html><body>Another response body.</body></html>"
      },
      type: "response",
      context: {
        test_framework: "test_unit",
        test_case_name: "DummyControllerTest",
        method_name: "test_some_controller_action",
        source_location: [
          "#{SnapshotInspector::Engine.root}/test/snapshot_inspector/test/test_unit_helpers_test.rb",
          6
        ],
        take_snapshot_index: 1
      },
      slug: "test/snapshot_inspector/test/test_unit_helpers_test_6_1",
      created_at: "2023-02-07T11:05:05.000Z"
    }

    snapshot1_file_path = SnapshotInspector::Storage.processing_directory.join("test/snapshot_inspector/test/test_unit_helpers_test_6_0.json")
    assert_equal JSON.pretty_generate(snapshot1_expected_contents), File.read(snapshot1_file_path)

    snapshot2_file_path = SnapshotInspector::Storage.processing_directory.join("test/snapshot_inspector/test/test_unit_helpers_test_6_1.json")
    assert_equal JSON.pretty_generate(snapshot2_expected_contents), File.read(snapshot2_file_path)
  end
end
