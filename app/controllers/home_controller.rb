# coding: utf-8

class HomeController < ApplicationController

  def index
    @home = true
    @title = "Make and take tests, surveys, and quizzes - Testeroni"
    @description = "Testeroni lets you make surveys and quizzes from YouTube videos."
    @tests = Tst.recently_published
  end
  
  def notes
  end
  
  def test
    render :layout => false
  end

end
