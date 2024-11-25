require "application_system_test_case"

class AmazonCredentialsTest < ApplicationSystemTestCase
  setup do
    @amazon_credential = amazon_credentials(:one)
  end

  test "visiting the index" do
    visit amazon_credentials_url
    assert_selector "h1", text: "Amazon credentials"
  end

  test "should create amazon credential" do
    visit amazon_credentials_url
    click_on "New amazon credential"

    fill_in "Access token", with: @amazon_credential.access_token
    fill_in "Refresh token", with: @amazon_credential.refresh_token
    fill_in "String", with: @amazon_credential.string
    click_on "Create Amazon credential"

    assert_text "Amazon credential was successfully created"
    click_on "Back"
  end

  test "should update Amazon credential" do
    visit amazon_credential_url(@amazon_credential)
    click_on "Edit this amazon credential", match: :first

    fill_in "Access token", with: @amazon_credential.access_token
    fill_in "Refresh token", with: @amazon_credential.refresh_token
    fill_in "String", with: @amazon_credential.string
    click_on "Update Amazon credential"

    assert_text "Amazon credential was successfully updated"
    click_on "Back"
  end

  test "should destroy Amazon credential" do
    visit amazon_credential_url(@amazon_credential)
    click_on "Destroy this amazon credential", match: :first

    assert_text "Amazon credential was successfully destroyed"
  end
end
