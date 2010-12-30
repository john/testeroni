# coding: utf-8

require "base64"

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

end
