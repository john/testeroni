# coding: utf-8

class SearchController < ApplicationController
  
  def results
    if params[:q]
      redirect_to "/search/#{params[:q]}"
    elsif params[:term]
      
      @name_results = Tst.find_by_sql(["SELECT * FROM tsts WHERE name LIKE ?", "%#{params[:term]}%"] )
      logger.debug "@name_results: #{@name_results.inspect}"
      
      @tag_results = Tst.tagged_with(params[:term])
      logger.debug "@tag_results: #{@tag_results.inspect}"
      
      @results = @name_results + @tag_results
      @results = @results.uniq
      @results
    end
  end
  
end
