require 'test_helper'

class ChoiceTest < ActiveSupport::TestCase

  should "get 'downcase test' for Choice.simplify('Downcase Test')" do
    assert_equal 'downcase test', Choice.simplify('Downcase Test')
  end
  
  should "get nil for Choice.simplify(nil)" do
    assert_equal nil, Choice.simplify(nil)
  end
  
  should "get 'donkeyboy' for Choice.simplify('donkey.boy')" do
    assert_equal 'donkeyboy', Choice.simplify('donkey.boy')
  end
  
  should "get 'monkeytoy' for Choice.simplify('monkey/toy')" do
    assert_equal 'monkeytoy', Choice.simplify('monkey/toy')
  end

end
