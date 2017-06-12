require 'test_helper'

class TodosTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.create(name: "Testy", email: "test@gmail.com", password: "password", password_confirmation: "password", admin: true)
    @user2 = User.create(name: "Tester", email: "tester@gmail.com", password: "password", password_confirmation: "password")
    @todo = @user.todos.build(name: "Todo", description: "Run away tests for tests.")
    @todo2 = @user.todos.build(name: "Hello There", description: "Just keep saying hello there.")
    @todo.save
    @todo2.save
  end

  test 'get todos index' do
    get todos_path
    assert_response :success
  end

  test 'todos index listings' do
    get todos_path
    assert_template 'todos/index'
    assert_select 'a[href=?]', todo_path(@todo), text: @todo.name
    assert_select 'a[href=?]', todo_path(@todo2), text: @todo2.name
  end

  test 'get todos show' do
    get todo_path(@todo)
    assert_response :success
    get todo_path(@todo2)
    assert_response :success
  end

  test 'todos show page listing' do
    sign_in_as(@user.email, @user.password)
    get todo_path(@todo)
    assert_template 'todos/show'
    assert_match @todo.name.capitalize, response.body
    assert_match @todo.description, response.body
    assert_select 'a[href=?]', edit_todo_path(@todo), text: "Edit this todo"
    assert_select 'a[href=?]', todo_path(@todo), text: "Delete this todo"
    assert_select 'a[href=?]', todos_path, text: "Back to todos listing"
  end

  test 'get todos new' do
    sign_in_as(@user.email, @user.password)
    get new_todo_path
    assert_response :success
  end

  test 'create valid new todos' do
    sign_in_as(@user.email, @user.password)
    get new_todo_path
    assert_template 'todos/new'
    new_name = "Do Laundry"
    new_description = "Wash clothes, dry clothes, fold clothes"
    assert_difference 'Todo.count', 1 do
      post todos_path, params: { todo: { name: new_name, description: new_description } } 
    end
    follow_redirect!
    assert_not flash.empty?
    assert_match new_name.capitalize, response.body
    assert_match new_description, response.body
  end

  test 'reject invalid new todos' do
    sign_in_as(@user.email, @user.password)
    get new_todo_path
    assert_template 'todos/new'
    new_name = ''
    new_description = ''
    assert_no_difference 'Todo.count' do
      post todos_path, params: { todo: { name: new_name, description: new_description } }
    end
    assert_template 'todos/new'
    assert_select 'div.panel-danger'
  end

  test 'get todos edit' do
    sign_in_as(@user.email, @user.password)
    get edit_todo_path(@todo)
    assert_response :success
    sign_in_as(@user2.email, @user2.password)
    get edit_todo_path(@todo2)
    assert_response :redirect
  end

  test 'create valid todo edits' do
    sign_in_as(@user.email, @user.password)
    get edit_todo_path(@todo)
    assert_template 'todos/edit'
    edit_name = "mow lawn"
    edit_description = "cut grass, kill weeds, rake leaves"
    patch todo_path(@todo), params: { todo: { name: edit_name, description: edit_description } }
    assert_redirected_to @todo
    assert_not flash.empty?
    @todo.reload
    assert_match edit_name, @todo.name
    assert_match edit_description, @todo.description
  end

  test 'reject invalid todo edits' do
    sign_in_as(@user.email, @user.password)
    get edit_todo_path(@todo)
    assert_template 'todos/edit'
    edit_name = ''
    edit_description = ''
    patch todo_path(@todo), params: { todo: { name: edit_name, description: edit_description } }
    assert_template 'todos/edit'
    assert_select 'div.panel-danger'
  end

  test 'successfully delete a todo' do
    sign_in_as(@user.email, @user.password)
    get todo_path(@todo)
    assert_template 'todos/show'
    assert_select "a[href=?]", todo_path(@todo), text: "Delete this todo"
    assert_difference "Todo.count", -1 do
      delete todo_path(@todo)
    end
    assert_redirected_to todos_path
    assert_not flash.empty?
  end
end
