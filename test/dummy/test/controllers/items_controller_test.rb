require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get items_path
    take_snapshot response
    assert_response :success
  end

  test "should get show" do
    get item_path(:one)
    take_snapshot response
    assert_response :success
  end
end
