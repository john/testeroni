# coding: utf-8

class SearchController < ApplicationController
  
  def results
    if params[:q]
      redirect_to "/search/#{params[:q]}"
    elsif params[:term]
      @name_results = Tst.find_by_sql(["SELECT * FROM tsts WHERE name LIKE ?", "%#{params[:term]}%"] )
      @tag_results = Tst.tagged_with(params[:term])
      @results = @name_results + @tag_results
      @results = @results.uniq
      @results
    end
  end
  
end
