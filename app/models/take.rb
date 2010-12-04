# coding: utf-8

class Take < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :tst
  has_many :responses
  
  validates :user_id, :presence => true, :numericality => true
  validates :tst_id, :presence => true, :numericality => true
  
end
