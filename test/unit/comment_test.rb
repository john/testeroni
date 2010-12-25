require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  should "get a comment by passing a commentable object, a user id, and some comment text to Comment.build_from" do
    @user = User.find(1)
    @test = Tst.find(1)
    @comment = Comment.build_from(@test, @user.id, 'hello, test!')
    
    assert_kind_of Comment, @comment
  end
  
  should_eventually "see if a comment has children" do
    @user = User.find(1)
    @test = Tst.find(1)
    @parent_comment = Comment.build_from(@test, @user.id, 'hello, test!')
    @parent_comment.save
    puts "parent_comment: #{@parent_comment.inspect}"
    
    @child_comment = Comment.build_from(@parent_comment, @user.id, 'hello, dad!')
    @child_comment.save
    puts "child_comment: #{@child_comment.inspect}"
    
    assert_equal true, Comment.find(@parent_comment.id).has_children?
  end
  
  # Helper class method to look up a commentable object
  # given the commentable class name and id
  # def self.find_commentable(commentable_str, commentable_id)
  should_eventually "find a commentable object by classname and id" do
    
  end

end
