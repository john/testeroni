# coding: utf-8

class Choice < ActiveRecord::Base
  
  TRUE = 1
  FALSE = 0
  MULTIPLE = 2
  SHORT = 3
  
  MAX_ALLOWED_CHOICES = 5
  
  belongs_to :question
  has_many :responses
  
  validates :name, :presence => true
  validates :question_id, :presence => true, :numericality => true
  
  def self.simplify(name)
    if name.nil?
      nil
    else
      # ALSO strip junk words like 'a', 'an', 'the'
      return name.downcase.strip.gsub('.', '').gsub('/', '')
    end
  end
  
end
