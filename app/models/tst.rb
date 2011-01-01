# coding: utf-8

class Tst < ActiveRecord::Base
  
  ANYONE = 0
  JUSTME = 1
  
  ACTIVE = 0
  CLOSED = 1
  ARCHIVED = 2
  SUSPENDED = 3
  
  # https://github.com/elight/acts_as_commentable_with_threading
  acts_as_commentable
  has_friendly_id :name, :use_slug => true
  acts_as_taggable
  
  attr_accessor :video_url
  
  belongs_to :user
  has_many :videos
  has_many :questions
  has_many :responses
  has_many :takes
  
  validates :name, :presence => true
  validates :user_id, :presence => true, :numericality => true
  # validation to make sure tests don't have more than 100 questions?
  
  scope :active, where(['status=?', Tst::ACTIVE])
  # http://edgerails.info/articles/what-s-new-in-edge-rails/2010/02/23/the-skinny-on-scopes-formerly-named-scope/
  # "Without the lambda the time that would be used in the query logic would be the time that the class was first evaluated, not the scope itself."
  scope :published, lambda {
    where("tsts.published_at IS NOT NULL AND tsts.published_at <= ?", Time.zone.now)
  }
  scope :recently_published, active.published.order("tsts.published_at DESC")
  
  def self.load_active_by_id(id)
    Tst.find_by_sql(['SELECT * FROM tsts WHERE id=? AND STATUS=? LIMIT 1', id, Tst::ACTIVE])[0]
  end
  
  def owned_by?(some_user)
    (user_id == some_user.id)
  end
  
  def published?
    (published_at.nil?) ? false : true
  end
  
  def has_questions?
    (questions.size > 0)
  end
  
  # TODO: This is horribly inefficient. Might eventually want to store a running total of correct answers
  # with each test, and update it as people take it. Would be better still if that update was batched:
  # keep the number needing to be updated in memory, write to the db every time it hits 10, or whatever.
  # Pain to do that with ruby :-(
  def percent_correct
    # @_percent_correct ||= begin
      @responses = Response.where(['tst_id=?', id])
      if @responses.size == 0
        0
      else
        @correct_responses = 0
        @responses.each do |r|
          @correct_responses += 1 if r.correct?
        end
        (((@correct_responses.to_f/@responses.size.to_f)*100)+0.5).to_i
      end
    # end
  end
  
  def grade
    @_grade ||= begin
      if percent_correct < 60
        'F'
      elsif percent_correct < 63
        'D-'
      elsif percent_correct < 67
        'D'
      elsif percent_correct < 70
        'D+'
      elsif percent_correct < 73
        'C-'
      elsif percent_correct < 77
        'C'
      elsif percent_correct < 80
        'C+'
      elsif percent_correct < 83
        'B-'
      elsif percent_correct < 87
        'B'
      elsif percent_correct < 90
        'B+'
      elsif percent_correct < 93
        'A-'
      elsif percent_correct < 97
        'A'
      else
        'A+'
      end
    end
  end
  
  def percent_correct_for(take)
  end
  
  def grade_for(take)
  end
  
end
