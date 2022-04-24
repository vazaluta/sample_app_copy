require 'test_helper'

class StaticpagesControllerTest < ActionDispatch::IntegrationTest
  
  test "should get root" do
    get staticpages_home_url
    assert_response :success
        assert_select "title", "Ruby on Rails Tutorial Sample App"

  end
  
  test "should get home" do
    get staticpages_home_url
    assert_response :success
    assert_select "title", "Ruby on Rails Tutorial Sample App"
  end

  test "should get help" do
    get staticpages_help_url
    assert_response :success
    assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
  end
  
  test "should get about" do
    get staticpages_about_url
    assert_response :success
    assert_select "title", "About | Ruby on Rails Tutorial Sample App"
  end
  
    test "should get contact" do
    get staticpages_contact_url
    assert_response :success
    assert_select "title", "Contact | Ruby on Rails Tutorial Sample App"
  end
end
