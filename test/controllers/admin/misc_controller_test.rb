require 'test_helper'

class Admin::MiscControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get admin_misc_dashboard_url
    assert_response :success
  end

end
