# coding: utf-8

class PeopleController < ApplicationController

  def show
    # if current_user && !params[:dislay_name]
    #   flash.each {|key, msg| flash[key] = msg }
    #   redirect_to person_with_name_path(current_user.id, current_user.name) and return
    # end

    # @person = User.find(params[:id])
    # @title = "#{@person.name} - Testeroni"
    # @description = "#{@person.name}'s homepage on Testeroni."
    # @owner = true if user_signed_in? && @person.id == current_user.id

    @person = User.find(params[:id])
    @tests_created = @person.tsts
    @tests_taken = @person.unique_tests_taken
  end

  def tests
    @person = User.find(params[:id])
    @tests_created = @person.tsts
    @tests_taken = @person.unique_tests_taken
  end

  # match 'people/:id/follow/:object_type/:object_id', :to => 'people#follow', :as 'follow'
  def follow
    @person = User.find(params[:id])
    unless user_signed_in? && @person == current_user
      redirect_to root_path and return
    else
      followee = Object.const_get(params[:object_type]).find(params[:object_id])
      @person.follow(followee)

      render :partial => 'follow'
    end
  end

  # match 'people/:id/unfollow/:object_type/:object_id', :to => 'people#unfollow', :as 'follow'
  def unfollow
    @person = User.find(params[:id])
    redirect_to root_path and return unless user_signed_in? && @person == current_user

    if the_follow = Follow.where(["follow_type = ? AND follow_id = ?", params[:object_type], params[:object_id]])
      the_follow[0].delete
      render :partial => 'unfollow'
    else
      render :text => 'fail!'
    end
  end

end
