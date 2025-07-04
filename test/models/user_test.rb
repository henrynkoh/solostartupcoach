require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @user.password = "Password123!@#"
    @user.password_confirmation = "Password123!@#"
  end

  test "should be valid with all required attributes" do
    assert @user.valid?
  end

  test "email should be present" do
    @user.email = nil
    assert_not @user.valid?
    assert_includes @user.errors[:email], "can't be blank"
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
  end

  test "email should be in valid format" do
    invalid_emails = %w[user@foo,com user_at_foo.org example.user@foo.]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should be invalid"
    end

    valid_emails = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
    valid_emails.each do |valid_email|
      @user.email = valid_email
      assert @user.valid?, "#{valid_email.inspect} should be valid"
    end
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 12
    assert_not @user.valid?
    assert_includes @user.errors[:password], "can't be blank"
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "aA1!" * 2 # 8 characters
    assert_not @user.valid?
    assert_includes @user.errors[:password], "is too short (minimum is 12 characters)"
  end

  test "password should have required complexity" do
    @user.password = @user.password_confirmation = "a" * 12 # lowercase only
    assert_not @user.valid?
    assert_includes @user.errors[:password], "must include at least one uppercase letter, one lowercase letter, one number, and one special character"

    @user.password = @user.password_confirmation = "A" * 12 # uppercase only
    assert_not @user.valid?
    assert_includes @user.errors[:password], "must include at least one uppercase letter, one lowercase letter, one number, and one special character"

    @user.password = @user.password_confirmation = "1" * 12 # numbers only
    assert_not @user.valid?
    assert_includes @user.errors[:password], "must include at least one uppercase letter, one lowercase letter, one number, and one special character"

    @user.password = @user.password_confirmation = "!" * 12 # special characters only
    assert_not @user.valid?
    assert_includes @user.errors[:password], "must include at least one uppercase letter, one lowercase letter, one number, and one special character"
  end
end
