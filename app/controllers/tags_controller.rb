# coding: utf-8

# from here: https://github.com/mbleigh/acts-as-taggable-on
class TagsController < ApplicationController
  
  def index
    @tags = Tst.tag_counts_on(:tags)
  end
  
  def show
    @tests = Tst.tagged_with(params[:id])
  end
  
end