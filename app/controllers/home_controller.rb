# coding: utf-8

class HomeController < ApplicationController

  def index
    @home = true
    @title = "Testeroni - Make and take tests and surveys"
    @description = "Testeroni lets you make surveys and quizzes from YouTube videos."
    @tests = Tst.recently_published
  end
  
  def notes
  end
  
  def test
    render :layout => false
  end

end
