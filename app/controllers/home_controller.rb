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
  
  # hide the cross-site, top-of-page promo
  def hide_promo
    session[:promo][:dismissed_at] = DateTime.now if session[:promo]
    render :nothing => true
  end

end
