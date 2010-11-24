# coding: utf-8

class Take < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :test
  has_many :responses
  
end
