# coding: utf-8

class SearchController < ApplicationController
  
  def results
    if params[:q]
      Test.find_by_sql(['SELECT * FROM tests WHERE name LIKE ?', params[:q]] )
    end
  end
  
end
