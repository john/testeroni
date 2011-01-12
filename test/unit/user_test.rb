require 'test_helper'

class UserTest < ActiveSupport::TestCase

  should "follow a user" do
    @user1 = User.find(1)
    @user2 = User.find(2)
    
    assert_equal true, @user1.follow(@user2)
  end
  
  should "say a user is following another user" do
    @user1 = User.find(1)
    @user2 = User.find(2)
    
    @user1.follow(@user2)
    assert_equal true, @user1.is_following?(@user2)
  end

end
