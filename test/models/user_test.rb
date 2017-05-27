require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.create(name: "Testy", email: "test@gmail.com")
  end

  test "user is valid" do 
    assert @user.valid?
  end
    
  test "name is present" do
    @user.name = ''
    assert_not @user.valid?
  end

  test "name should be less than 30 characters" do
    @user.name = "a" * 31
    assert_not @user.valid?
  end

  test "email is present" do
    @user.email = ''
    assert_not @user.valid?
  end

  test "email should be less than 255 characters" do
    @user.email = "a" * 256
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email regex format is correct" do
    valid_emails = %w[test@example.com test.dot@gmail.com test+test@gmail.uk.org]
    valid_emails.each do |valids|
      @user.email = valids
      assert @user.valid?, "#{valids.inspect} should be valid"
    end
  end

  test "email regex format is not correct" do
    invalid_emails = %w[test@example test.dot@gmail,com test+test@gmail+uk.org]
    invalid_emails.each do |invalids|
      @user.email = invalids
      assert_not @user.valid?, "#{invalids.inspect} shouldn't be valid"
    end
  end

  test "email should be lowercase before hitting db" do
    uppercase = "tYRHEJe@gMail.Com"
    @user.email = uppercase
    @user.save
    assert_equal uppercase.downcase, @user.reload.email
  end

end