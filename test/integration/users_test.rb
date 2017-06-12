require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(name: "Test", email: "test@gmail.com", password: "password", password_confirmation: "password")
    @user2 = User.create(name: "Tester", email: "tester@gmail.com", password: "password", password_confirmation: "password")
  end

  test "should get users index page" do
    get users_path
    assert_response :success
  end

  test "new user can create account" do
    get signup_path
    assert_template "users/new"
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: "Testing", email: "testing@gmail.com", password: "password", password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template "users/show"
    assert_not flash.empty?
  end

  test "new user rejected from creating account" do
    get signup_path
    assert_template "users/new"
    assert_no_difference "User.count" do
      post users_path, params: { user: { name: '', email: '', password: '', password_confirmation: '' } }
    end
    assert_template "users/new"
    assert_select "div.panel-body"
  end
end
