require 'test_helper'

class CryptoKeysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @crypto_key = crypto_keys(:one)
  end

  test "should get index" do
    get crypto_keys_url
    assert_response :success
  end

  test "should get new" do
    get new_crypto_key_url
    assert_response :success
  end

  test "should create crypto_key" do
    assert_difference('CryptoKey.count') do
      post crypto_keys_url, params: { crypto_key: { name: @crypto_key.name, owner_id: @crypto_key.owner_id, owner_type: @crypto_key.owner_type, private_pem: @crypto_key.private_pem, public_pem: @crypto_key.public_pem } }
    end

    assert_redirected_to crypto_key_url(CryptoKey.last)
  end

  test "should show crypto_key" do
    get crypto_key_url(@crypto_key)
    assert_response :success
  end

  test "should get edit" do
    get edit_crypto_key_url(@crypto_key)
    assert_response :success
  end

  test "should update crypto_key" do
    patch crypto_key_url(@crypto_key), params: { crypto_key: { name: @crypto_key.name, owner_id: @crypto_key.owner_id, owner_type: @crypto_key.owner_type, private_pem: @crypto_key.private_pem, public_pem: @crypto_key.public_pem } }
    assert_redirected_to crypto_key_url(@crypto_key)
  end

  test "should destroy crypto_key" do
    assert_difference('CryptoKey.count', -1) do
      delete crypto_key_url(@crypto_key)
    end

    assert_redirected_to crypto_keys_url
  end
end
