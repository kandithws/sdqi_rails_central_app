require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get user_edit_url
    assert_response :success
  end

  test "should get update" do
    get user_update_url
    assert_response :success
  end

  test "should get upload_license_plate" do
    get user_upload_license_plate_url
    assert_response :success
  end

end
