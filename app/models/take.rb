# coding: utf-8

class Take < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :tst
  has_many :responses
  
  validates :user_id, :presence => true, :numericality => true
  validates :tst_id, :presence => true, :numericality => true
  
  def sessionize
    responses_hash = responses.map{|r| {:q => r.question_id, :c => r.choice_id, :a => r.answer, :cr => r.correct, :n => r.name}}
    {:t => tst_id, :s => started_at.to_i, :f => finished_at.to_i, :a => questions_answered, :c => questions_correct, :r => responses_hash }
  end
  
  def self.desessionize(session)
    tk = session[:take]
    take = Take.new(  :tst_id => tk[:t],
                      :started_at => Time.at(tk[:s]/1000.0),
                      :questions_answered => tk[:a],
                      :questions_correct => tk[:c])
    
    responses = tk[:r].map {|r| Response.new(:tst_id => tk[:t], :question_id => r[:q], :choice_id => r[:c], :answer => r[:a], :correct => r[:cr], :name => r[:n]) }
    take.responses = responses
    take
  end
  
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
  end
  
end
