# coding: utf-8

# https://github.com/elight/acts_as_commentable_with_threading
class CommentsController < ApplicationController
  
  # get the comments on an object
  def show
  end
  
  # add a comment to an object
  def create
    redirect_to root_path and return unless user_signed_in?
    
    @commented_on = Object.const_get(params[:comment][:commentable_type]).find(params[:comment][:commentable_id])
    @comment = Comment.build_from(@commented_on, current_user.id, params[:comment_text] )
    
    if params[:comment][:commentable_type] == 'Tst'
      @comment.tst_id = params[:comment][:commentable_id]
    end
    
    if params[:comment][:commentable_type] == 'Question'
      @comment.question_id = params[:comment][:commentable_id]
      
      @question = Question.find(params[:comment][:commentable_id])
      @comment.tst_id = @question.tst_id
    end
    
    if params[:question_id]
       @comment.question_id = params[:question_id]
    end
    
    @comment.user = current_user
    @comment.save
    record_activity(current_user, Activity::COMMENT, @commented_on)
    
    if params[:comment][:commentable_type] == 'Tst'
      @comment = Comment.new(:commentable_type => @commented_on.class, :commentable_id => @commented_on.id)
    end
    
    render :partial => 'shared/comments', :locals => {:commentable => @commented_on, :comment => @comment, :comments => @commented_on.root_comments, :added_id => @comment.id}
  end
  
  # return a comment editing form
  def edit
  end
  
  # update an existing comment
  def update
  end
  
  # nuke comment
  def destroy
  end
  
end