require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get items_path
    take_snapshot response
    assert_response :success
  end

  test "should show item" do
    get item_path(:one)
    take_snapshot response
    assert_response :success
  end

  test "should create item" do
    post items_path, params: { item: {name: "Example Name"} }
    take_snapshot response
    assert_redirected_to item_path(:one, name: "Example Name")

    follow_redirect!
    take_snapshot response
  end
end
