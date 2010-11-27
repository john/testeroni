# coding: utf-8

class Question < ActiveRecord::Base
  
  TRUEFALSE = 1
  MULTIPLECHOICE = 2
  SHORTANSWER = 3
  
  # https://github.com/elight/acts_as_commentable_with_threading
  acts_as_commentable
  
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
  
  # if it's a multiple choice question, get the correct one
  def correct_choice
    @_correct_choice ||= begin
      choices.each do |c|
        return c if c.correct?
      end
    end
  end
  
  def is_multiple_choice
    (kind == Question::MULTIPLECHOICE) ? true : false
  end
  
  def is_short_answer
    (kind == Question::SHORTANSWER) ? true : false
  end
  
end
