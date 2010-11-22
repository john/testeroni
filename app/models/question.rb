class Question < ActiveRecord::Base
  
  TRUEFALSE = 1
  MULTIPLECHOICE = 2
  
  belongs_to :test
  belongs_to :user
  has_many :choices
  has_many :responses
  has_many :videos
  
  # this should probably be stored in the question, so
  # this it doesn't have to do the calculation ever time
  def number_correct
    @correct = 0
    responses.each do |r|
      @correct += 1 if r.correct
    end
    @correct
  end
  
  validates :name, :presence => true
  validates :kind, :presence => true
  validates :test_id, :presence => true, :numericality => true
  validates :user_id, :presence => true, :numericality => true
  
end
