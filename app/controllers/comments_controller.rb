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
    @comment.user = current_user
    @comment.save
    flash[:notice] = 'Comment added.'
    render :partial => 'shared/comments', :locals => {:comment => Comment.new, :comments => @commented_on.root_comments, :added_id => @comment.id}
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