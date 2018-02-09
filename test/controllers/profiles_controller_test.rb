require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get profiles_edit_url
    assert_response :success
  end

  test "should get update" do
    get profiles_update_url
    assert_response :success
  end

  test "should get destroy" do
    get profiles_destroy_url
    assert_response :success
  end

end
