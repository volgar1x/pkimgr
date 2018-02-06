require 'test_helper'

class CertProfileConstraintsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cert_profile_constraint = cert_profile_constraints(:one)
  end

  test "should get index" do
    get cert_profile_constraints_url
    assert_response :success
  end

  test "should get new" do
    get new_cert_profile_constraint_url
    assert_response :success
  end

  test "should create cert_profile_constraint" do
    assert_difference('CertProfileConstraint.count') do
      post cert_profile_constraints_url, params: { cert_profile_constraint: { profile_id: @cert_profile_constraint.profile_id, type: @cert_profile_constraint.type, value: @cert_profile_constraint.value } }
    end

    assert_redirected_to cert_profile_constraint_url(CertProfileConstraint.last)
  end

  test "should show cert_profile_constraint" do
    get cert_profile_constraint_url(@cert_profile_constraint)
    assert_response :success
  end

  test "should get edit" do
    get edit_cert_profile_constraint_url(@cert_profile_constraint)
    assert_response :success
  end

  test "should update cert_profile_constraint" do
    patch cert_profile_constraint_url(@cert_profile_constraint), params: { cert_profile_constraint: { profile_id: @cert_profile_constraint.profile_id, type: @cert_profile_constraint.type, value: @cert_profile_constraint.value } }
    assert_redirected_to cert_profile_constraint_url(@cert_profile_constraint)
  end

  test "should destroy cert_profile_constraint" do
    assert_difference('CertProfileConstraint.count', -1) do
      delete cert_profile_constraint_url(@cert_profile_constraint)
    end

    assert_redirected_to cert_profile_constraints_url
  end
end
