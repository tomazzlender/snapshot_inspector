require "test_helper"

class FlowTest < ActionDispatch::IntegrationTest
  test "common user flow" do
    get root_path
    take_snapshot response
    get items_path
    take_snapshot response
    get about_path
    take_snapshot response
  end
end
