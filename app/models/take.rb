# coding: utf-8

class Take < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :tst
  has_many :responses
  
  validates :user_id, :presence => true, :numericality => true
  validates :tst_id, :presence => true, :numericality => true
  
  def sessionize
    responses_hash = responses.map{|r| {:q => r.question_id, :c => r.choice_id, :a => r.answer, :cr => r.correct, :n => r.name}}
    {:t => tst_id, :s => started_at.to_i, :a => questions_answered, :c => questions_correct, :r => responses_hash }
  end
  
  def self.desessionize(session)
    tk = session[:take]
    take = Take.new(:tst_id => tk[:t], :started_at => Time.at(tk[:s]/1000.0), :questions_answered => tk[:a], :questions_correct => tk[:c])
    
    responses = tk[:r].map {|r| Response.new(:tst_id => tk[:t], :question_id => r[:q], :choice_id => r[:c], :answer => r[:a], :correct => r[:cr], :name => r[:n]) }
    take.responses = responses
    take
  end
  
end
