require "test_helper"

class SnapshotInspector::Snapshot::ResponseTypeTest < ActiveSupport::TestCase
  test "::extract, ::from_hash, #body" do
    response = ActionDispatch::TestResponse.from_response(Struct.new(:body, :status, :headers).new(body: "<html><!-- Example -></html>", status: 200, headers: {}))
    response_type = SnapshotInspector::Snapshot::Type.extract(response)

    assert_equal "<html><!-- Example -></html>", response_type.body

    response_type_from_hash = SnapshotInspector::Snapshot::Type.from_hash(JSON.parse(response_type.to_json, symbolize_names: true))
    assert_equal "<html><!-- Example -></html>", response_type_from_hash.body
  end
end
