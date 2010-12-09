# coding: utf-8

class TagsController < ApplicationController
  
  def index
    @tags = Tst.tag_counts_on(:tags)
  end
  
  def show
    @tests = Tst.tagged_with(params[:id])
  end
  
end