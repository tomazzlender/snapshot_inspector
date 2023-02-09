require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_path
    take_snapshot response
    assert_response :success
  end

  test "should get edit" do
    get edit_user_path(:one)
    take_snapshot response
    assert_response :success

    get edit_user_path(:second)
    take_snapshot response
    assert_response :success
  end
end
