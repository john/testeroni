# coding: utf-8

class Take < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :tst
  has_many :responses
  
  # http://api.rubyonrails.org/classes/ActiveRecord/Base.html
  # would require renaming db column from question_order to question_ids
  # serialize :question_ids
  
  validates :user_id, :presence => true, :numericality => true
  validates :tst_id, :presence => true, :numericality => true
  
  def sessionize
    responses_hash = responses.map{|r| {:q => r.question_id, :c => r.choice_id, :a => r.answer, :cr => r.correct, :n => r.name}}
    {:ta => id, :u => user_id, :te => tst_id, :s => started_at.to_i, :f => finished_at.to_i, :a => questions_answered, :c => questions_correct, :r => responses_hash, :qo => question_order}
  end
  
  def self.desessionize(session)
    tk = session[:take]
    take = Take.new(  :user_id => tk[:u],
                      :tst_id => tk[:te],
                      :started_at => Time.at(tk[:s]/1000.0),
                      :questions_answered => tk[:a],
                      :questions_correct => tk[:c],
                      :question_order => tk[:qo])
    take.id = tk[:ta] if tk.has_key?(:ta)
    responses = tk[:r].map {|r| Response.new(:tst_id => tk[:t], :question_id => r[:q], :choice_id => r[:c], :answer => r[:a], :correct => r[:cr], :name => r[:n]) }
    take.responses = responses
    take
  end
  
  def self.find_from_session_or_params(params, session)
    if !params[:take_id].blank?
      Take.find(params[:take_id])
    elsif session[:take]
      Take.desessionize(session)
    else
      nil
    end
  end
  
  # Used when someone has taken a test when not logged in, and they then either signup or log in, and the test tey just took needs to be persisted
  def self.save_from_session_for_user(session, user)
    @take = Take.desessionize(session)
    @take.user_id = user.id
    @take.created_at = Time.now
    @take.updated_at = Time.now
    @take.finished_at = Time.now
    
    # prolly a better way to do this, but need to detach the responses so that validations pass when you save the take
    @responses = []
    @take.responses.each {|r| @responses << r}
    @take.responses = []
    @take.save
    
    @responses.each do |r|
      r.user_id = @take.user_id
      r.take_id = @take.id
      r.save
    end
    session[:take] = nil
    @take
  end
  
  def question_ids
    if question_order.nil?
      []
    else
      question_order.split(',').map{|qid| qid.to_i}
    end
  end
  
end
