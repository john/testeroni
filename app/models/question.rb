class Question < ApplicationRecord

  TRUEFALSE = 1
  MULTIPLECHOICE = 2
  SHORTANSWER = 3

  # has_friendly_id :name, :use_slug => true
  extend FriendlyId
  friendly_id :name, use: :slugged

  # https://github.com/elight/acts_as_commentable_with_threading
  # acts_as_commentable

  belongs_to :tst
  belongs_to :user
  has_many :choices
  has_many :responses
  has_many :videos

  validates :name, :presence => true
  validates :kind, :presence => true
  validates :tst_id, :presence => true, :numericality => true
  validates :user_id, :presence => true, :numericality => true

  def first?
    ids = tst.questions.pluck(:id)
    (ids.first == self.id) ? true : false
  end

  def last?
    ids = tst.questions.pluck(:id)
    (ids.last == self.id) ? true : false
  end

  def remaining_in_test
    (tst.questions.length - current_position) - 1
  end

  def current_position
    ids = tst.questions.pluck(:id)
    ids.index(self.id)
  end

  def next_question
    return nil if last?
    tst.questions[current_position + 1]
  end

  # total number of times this question has been answered correctly,
  # across all takes. this should probably be stored in the question, so
  # this it doesn't have to do the calculation every time
  def number_correct
    @correct = 0
    responses.each do |r|
      @correct += 1 if r.correct
    end
    @correct
  end

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

  # def get_nonzero_position_in_id_array(question_ids)
  #   question_ids.each_with_index do |qid, i|
  #     return i+1 if qid == id
  #   end
  # end

end
