class Test < ActiveRecord::Base
  
  attr_accessor :video_url
  
  belongs_to :user
  has_many :videos
  has_many :questions
  has_many :responses
  has_many :completions, :class_name => 'CompletedTest'
  
  has_friendly_id :name, :use_slug => true
  acts_as_taggable
  
  validates :name, :presence => true
  validates :user_id, :presence => true, :numericality => true
  
  # http://edgerails.info/articles/what-s-new-in-edge-rails/2010/02/23/the-skinny-on-scopes-formerly-named-scope/
  # "Without the lambda the time that would be used in the query logic would be the time that the class was first evaluated, not the scope itself."
  scope :published, lambda {
    where("tests.published_at IS NOT NULL AND tests.published_at <= ?", Time.zone.now)
  }
  scope :recently_published, published.order("tests.published_at DESC")
  
  def owned_by?(some_user)
    (user_id == some_user.id)
  end
  
  def published?
    (published_at.nil?) ? false : true
  end
  
  def has_questions?
    (questions.size > 0)
  end
  
end
