# coding: utf-8

class SearchController < ApplicationController
  
  def results
    if params[:q]
      redirect_to "/search/#{params[:q]}"
    elsif params[:term]
      @results = Tst.find_by_sql(["SELECT * FROM tsts WHERE name LIKE ?", "%#{params[:term]}%"] )
      logger.debug "GOT #{@results.size} results"
    else
    end
  end
  
end
