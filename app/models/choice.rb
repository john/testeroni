class Choice < ActiveRecord::Base
  
  TRUE = 1
  FALSE = 0
  MULTIPLE = 2
  
  belongs_to :question
  has_many :responses
  
  validates :name, :presence => true
  validates :question_id, :presence => true, :numericality => true
  
end
