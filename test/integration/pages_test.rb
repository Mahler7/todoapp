require 'test_helper'

class PagesTest < ActionDispatch::IntegrationTest
  test "get root url" do
    get root_url
    assert_response :success
  end

  test "get about url" do
    get about_path
    assert_response :success
  end

  test "get help url" do
    get help_path
    assert_response :success
  end
end
