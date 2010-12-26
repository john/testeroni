require 'test_helper'

class TstTest < ActiveSupport::TestCase

  should "call load_active_by_id(1) and get back an active test" do
    active_test = Tst.load_active_by_id(1)
    assert_equal Tst.find(1).id, active_test.id
  end
  
  should "call load_active_by_id(2) and get back nil, since test 2 is in the state 'closed'" do
    active_test = Tst.load_active_by_id(2)
    assert_equal nil, active_test
  end
  
  should "be owned_by 'john'" do
    @test = Tst.find(1)
    @user = User.find(1)
    assert_equal true, @test.owned_by?(@user)
  end
  
  should "be not be owned_by 'doug'" do
    @test = Tst.find(1)
    @user = User.find(2)
    assert_equal false, @test.owned_by?(@user)
  end
  
  should "be published" do
    @test = Tst.find(1)
    assert_equal true, @test.published?
  end
  
  should "not be published" do
    @test = Tst.find(2)
    assert_equal false, @test.published?
  end
  
  should "have questions" do
    @test = Tst.find(1)
    assert_equal true, @test.has_questions?
  end
  
  should "not have questions" do
     @test = Tst.find(2)
     assert_equal false, @test.has_questions?
  end

end
