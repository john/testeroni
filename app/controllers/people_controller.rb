# coding: utf-8

# require "base64"

class PeopleController < ApplicationController

  def show
    # if current_user && !params[:dislay_name]
    #   flash.each {|key, msg| flash[key] = msg }
    #   redirect_to person_with_name_path(current_user.id, current_user.display_name) and return
    # end
    
    @person = User.find(params[:id])
    @title = "#{@person.display_name} - Testeroni"
    @description = "#{@person.display_name}'s homepage on Testeroni."
    @owner = true if user_signed_in? && @person.id == current_user.id
  end
  
  # match 'people/:id/follow/:object_type/:object_id', :to => 'people#follow', :as 'follow'
  def follow
    @person = User.find(params[:id])
    unless user_signed_in? && @person == current_user
      redirect_to root_path and return
    else
      if params[:object_type] == 'Tst'
        ftype = Follow::TST
      elsif params[:object_type] == 'User'
        ftype = Follow::USER
      end
      Follow.create(:user_id => @person.id, :follow_type => ftype, :follow_id => params[:object_id])
      render :text => 'success!'
    end
  end
  
  # match 'people/:id/unfollow/:object_type/:object_id', :to => 'people#unfollow', :as 'follow'
  def unfollow
    @person = User.find(params[:id])
    redirect_to root_path and return unless user_signed_in? && @person == current_user
    
    the_follow = Follow.where(["follow_type = ? AND follow_id = ?", params[:object_type], params[:object_id]])[0]
    the_follow.delete
    render :text => 'success!'
  end

end
