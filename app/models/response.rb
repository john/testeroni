# coding: utf-8

class Response < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :tst
  belongs_to :question
  belongs_to :choice
  belongs_to :take
  
  validates :user_id, :presence => true, :numericality => true
  validates :tst_id, :presence => true, :numericality => true
  validates :question_id, :presence => true, :numericality => true
  
  # don't validate take_id, because responses before a person is logged in won't have one
  # validates :take_id, :presence => true, :numericality => true
  
  # don't validate choice_id, because if it's a true/false question, it's null
  # validates :choice_id, :presence => true, :numericality => true
  
end