require 'test_helper'

class CertSigningRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cert_signing_request = cert_signing_requests(:one)
  end

  test "should get index" do
    get cert_signing_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_cert_signing_request_url
    assert_response :success
  end

  test "should create cert_signing_request" do
    assert_difference('CertSigningRequest.count') do
      post cert_signing_requests_url, params: { cert_signing_request: { pem: @cert_signing_request.pem, profile_id: @cert_signing_request.profile_id, subject_id: @cert_signing_request.subject_id, subject_type: @cert_signing_request.subject_type } }
    end

    assert_redirected_to cert_signing_request_url(CertSigningRequest.last)
  end

  test "should show cert_signing_request" do
    get cert_signing_request_url(@cert_signing_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_cert_signing_request_url(@cert_signing_request)
    assert_response :success
  end

  test "should update cert_signing_request" do
    patch cert_signing_request_url(@cert_signing_request), params: { cert_signing_request: { pem: @cert_signing_request.pem, profile_id: @cert_signing_request.profile_id, subject_id: @cert_signing_request.subject_id, subject_type: @cert_signing_request.subject_type } }
    assert_redirected_to cert_signing_request_url(@cert_signing_request)
  end

  test "should destroy cert_signing_request" do
    assert_difference('CertSigningRequest.count', -1) do
      delete cert_signing_request_url(@cert_signing_request)
    end

    assert_redirected_to cert_signing_requests_url
  end
end
