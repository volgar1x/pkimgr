require 'test_helper'

class CertProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cert_profile = cert_profiles(:one)
  end

  test "should get index" do
    get cert_profiles_url
    assert_response :success
  end

  test "should get new" do
    get new_cert_profile_url
    assert_response :success
  end

  test "should create cert_profile" do
    assert_difference('CertProfile.count') do
      post cert_profiles_url, params: { cert_profile: { name: @cert_profile.name } }
    end

    assert_redirected_to cert_profile_url(CertProfile.last)
  end

  test "should show cert_profile" do
    get cert_profile_url(@cert_profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_cert_profile_url(@cert_profile)
    assert_response :success
  end

  test "should update cert_profile" do
    patch cert_profile_url(@cert_profile), params: { cert_profile: { name: @cert_profile.name } }
    assert_redirected_to cert_profile_url(@cert_profile)
  end

  test "should destroy cert_profile" do
    assert_difference('CertProfile.count', -1) do
      delete cert_profile_url(@cert_profile)
    end

    assert_redirected_to cert_profiles_url
  end
end
