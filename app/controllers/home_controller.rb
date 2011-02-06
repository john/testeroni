# coding: utf-8

class HomeController < ApplicationController

  def index
    @home = true
    @title = "Testeroni - Make and take tests and surveys"
    @description = "Testeroni lets you make surveys and quizzes from YouTube videos."
    # @tests = Tst.recently_published
    
    # the join with questions is to insure empty tests aren't displayed
    @tests = Tst.find_by_sql(["
      SELECT DISTINCT t.* from tsts t, questions q
      WHERE q.tst_id = t.id
      AND t.published_at IS NOT NULL
      AND t.published_at <= ?
      ORDER BY t.published_at DESC", Time.zone.now])
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
  
  def blohg
  end

end
