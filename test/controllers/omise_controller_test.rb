require 'test_helper'

class OmiseControllerTest < ActionDispatch::IntegrationTest
  test "should get omise_callback" do
    get omise_omise_callback_url
    assert_response :success
  end

end
