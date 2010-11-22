# coding: utf-8

class HomeController < ApplicationController

  def index
    @home = true
    @user = User.new(:email_list => true) #for hidden signup form
    @title = "Make surveys and quizzes from YouTube videos - Testeroni"
    @description = "Testeroni lets you make surveys and quizzes from YouTube videos."
    @tests = Test.recently_published
  end
  
  def notes
  end

end
