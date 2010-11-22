class Response < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :test
  belongs_to :question
  belongs_to :choice
  belongs_to :taking
  
  validates :user_id, :presence => true, :numericality => true
  validates :test_id, :presence => true, :numericality => true
  validates :question_id, :presence => true, :numericality => true
  
  # don't validate this, because if it's a true/false question, it's null
  # validates :choice_id, :presence => true, :numericality => true
  
end