require 'test_helper'

class TodoTest < ActiveSupport::TestCase

  def setup
    @user = User.create(name: "Testy", email: "test@gmail.com")
    @todo = @user.todos.build(name: "Todo", description: "Run away tests for tests.")
  end

  test "todo should be valid" do
    assert @todo.valid?
  end

  test "name should be present" do
    @todo.name = ''
    assert_not @todo.valid?
  end

  test "description should be present" do
    @todo.description = ''
    assert_not @todo.valid?
  end

  test "user should be present" do
    @todo.user_id = nil
    assert_not @todo.valid?
  end
end