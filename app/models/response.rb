class Response < ApplicationRecord

  belongs_to :user
  belongs_to :tst
  belongs_to :question
  belongs_to :choice
  belongs_to :take

  # attr_accessible :id, :tst_id, :question_id, :choice_id, :answer, :correct, :name

  # record responses from anonymous takers
  # validates :user_id, :presence => true, :numericality => true
  validates :tst_id, :presence => true, :numericality => true
  validates :question_id, :presence => true, :numericality => true

  # don't validate take_id, because responses before a person is logged in won't have one
  # validates :take_id, :presence => true, :numericality => true

  # don't validate choice_id, because if it's a true/false question, it's null
  # validates :choice_id, :presence => true, :numericality => true

end
