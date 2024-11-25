require "test_helper"

class AmazonCredentialsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @amazon_credential = amazon_credentials(:one)
  end

  test "should get index" do
    get amazon_credentials_url
    assert_response :success
  end

  test "should get new" do
    get new_amazon_credential_url
    assert_response :success
  end

  test "should create amazon_credential" do
    assert_difference("AmazonCredential.count") do
      post amazon_credentials_url, params: { amazon_credential: { access_token: @amazon_credential.access_token, refresh_token: @amazon_credential.refresh_token, string: @amazon_credential.string } }
    end

    assert_redirected_to amazon_credential_url(AmazonCredential.last)
  end

  test "should show amazon_credential" do
    get amazon_credential_url(@amazon_credential)
    assert_response :success
  end

  test "should get edit" do
    get edit_amazon_credential_url(@amazon_credential)
    assert_response :success
  end

  test "should update amazon_credential" do
    patch amazon_credential_url(@amazon_credential), params: { amazon_credential: { access_token: @amazon_credential.access_token, refresh_token: @amazon_credential.refresh_token, string: @amazon_credential.string } }
    assert_redirected_to amazon_credential_url(@amazon_credential)
  end

  test "should destroy amazon_credential" do
    assert_difference("AmazonCredential.count", -1) do
      delete amazon_credential_url(@amazon_credential)
    end

    assert_redirected_to amazon_credentials_url
  end
end
