require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_path
    take_snapshot response
    assert_response :success
  end

  test "should get about" do
    get about_path
    take_snapshot response
    assert_response :success
  end

  test "should get privacy" do
    get privacy_path
    take_snapshot response
    assert_response :success
  end
end
