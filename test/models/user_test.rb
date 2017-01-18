require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = User.new(name: "Ex User", email: "user@gmail.com",
                     password: "foobaroo", password_confirmation: "foobaroo")
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should be present" do
  	@user.name = ""
  	@user.email = ""
  	# assert @user.valid?
  	assert_not @user.valid?
  end

  test "email should be uniqueness" do
    du = @user.dup
    du.email.upcase!
    # du.email = @user.email.upcase
    @user.save
    # assert du.valid?
    assert_not du.valid?
  end

  test "email address should be saved as lower-case" do
    ex_email = "Foo@ExAMPle.CoM"
    @user.email = ex_email
    @user.save
    assert_equal ex_email.downcase, @user.reload.email
  end

    test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end


end
