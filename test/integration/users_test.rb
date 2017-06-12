require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  def setup
    @admin = User.create(name: "Admin", email: "admin@gmail.com", password: "password", password_confirmation: "password", admin: true)
    @user = User.create(name: "Test", email: "test@gmail.com", password: "password", password_confirmation: "password")
    @user2 = User.create(name: "Tester", email: "tester@gmail.com", password: "password", password_confirmation: "password")
    @todo = Todo.create(name: "Todo", description: "Things to do", user_id: @user.id)
  end

  test "should get users index page" do
    get users_path
    assert_response :success
  end

  test "should get users index listing" do
    get users_path
    assert_template "users/index"
    assert_select "a[href=?]", user_path(@user), text: @user.name
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

  test "user can sign in" do
    get sign_in_path
    assert_template "sessions/new"
    post sign_in_path, params: { session: { email: @user.email, password: @user.password } }
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_not flash.empty?
    assert_select "a[href=?]", sign_in_path, count: 0
    assert_select "a[href=?]", sign_out_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
  end

  test "invalid user can't sign in" do
    get sign_in_path
    assert_template "sessions/new"
    post sign_in_path, params: { session: { email: '', password: '' } }
    assert_template "sessions/new"
    assert_not flash.empty?
    assert_select "a[href=?]", sign_in_path
    assert_select "a[href=?]", sign_out_path, count: 0
    # get root_path
    # assert flash.empty?
  end

  test "user show page displaying correct data" do
    get user_path(@user)
    assert_template "users/show"
    assert_select "a[href=?]", todo_path(@todo)
    assert_match "Test", @user.name
    assert_match  @todo.name, response.body
    assert_match @todo.description, response.body
  end

  test "user can edit their profile" do
    #sign_in_as(@user.email, @user.password)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: { user: { name: "John", email: "john@example.com" } }
    assert_redirected_to @user
    assert_not flash.empty?
    @user.reload
    assert_match "John", @user.name
    assert_match "john@example.com", @user.email 
  end

  test "user profile edit errors" do
    #sign_in_as(@user.email, @user.password)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: { user: { name: '', password: '' } }
    assert_template "users/edit"
    assert_select "div.panel-danger"
  end

  test "admin can edit their profile" do
    sign_in_as(@admin.email, @admin.password)
    get edit_user_path(@admin)
    assert_template "users/edit"
    patch user_path(@admin), params: { user: { name: "John", email: "john@example.com" } }
    assert_redirected_to @admin
    assert_not flash.empty?
    @admin.reload
    assert_match "John", @admin.name
    assert_match "john@example.com", @admin.email
  end

  test "admin edit profile errors" do
    sign_in_as(@user.email, @user.password)
    patch user_path(@admin), params: { user: { name: "", email: "" } }
    assert_redirected_to users_path
    assert_not flash.empty?
    @admin.reload
    assert_match "Admin", @admin.name
    assert_match "admin@gmail.com", @admin.email
  end

  test "user can delete profile" do
    sign_in_as(@admin.email, @admin.password)
    get users_path
    assert_template "users/index"
    assert_difference "User.count", -1 do
      delete user_path(@user)
    end
    assert_redirected_to users_path
    assert_not flash.empty?
  end
end
