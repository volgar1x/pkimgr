require 'test_helper'

class MiscControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get misc_dashboard_url
    assert_response :success
  end

end
