# coding: utf-8

class PeopleController < ApplicationController

  def show
    
    if current_user && !params[:username]
      flash.each {|key, msg| flash[key] = msg }
      redirect_to people_path(url_escape(current_user.username)) and return
    end
    
    @person = User.find_by_username(current_user.username)
    @title = "#{@person.username} - Testeroni"
    @description = "#{@person.username}'s homepage on Testeroni."
  end

end
