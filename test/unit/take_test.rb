require 'test_helper'

class TakeTest < ActiveSupport::TestCase

  # responses_hash = responses.map{|r| {:q => r.question_id, :c => r.choice_id, :a => r.answer, :cr => r.correct, :n => r.name}}
  # {:t => tst_id, :s => started_at.to_i, :f => finished_at.to_i, :a => questions_answered, :c => questions_correct, :r => responses_hash, :qo => question_order }
  should "test 'sessionize': given a take, return a hash representing it, suitable for use in the session" do
    @take = Take.find(1)
    
    # DEAL WITH response array
    
    take_hash = {:ta => 1, :u => 1, :te => 1, :s => 1293196670, :f => 0, :a => 0, :c => 0, :r => [], :qo => "1,2"}
    
    assert_equal take_hash, @take.sessionize
  end
  
  should "test 'desessionize': given a session containing a take, create a Take object" do
    session = {}
    session[:take] = {:te=>1, :u=>1, :ta=>1, :s=>1293196670, :f=>0, :a=>0, :c=>0, :r=>[], :qo=>"1,2"}
    @take = Take.find(1)
    @take_from_session = Take.desessionize(session)
    
    assert_equal @take, @take_from_session
  end
  
  should "test 'find_from_session_or_params' by passing in a param :take_id" do
    params = {}
    session = {}
    params[:take_id] = 1
    
    assert_equal Take.find(1), Take.find_from_session_or_params(params, session)
  end
  
  should "test 'find_from_session_or_params' by passing in a session hash contailing :take" do
    params = {}
    session = {}
    session[:take] = {:te=>1, :u=>1, :ta=>1, :s=>1293196670, :f=>0, :a=>0, :c=>0, :r=>[], :qo=>"1,2"}
    
    assert_equal Take.find(1), Take.find_from_session_or_params(params, session)
  end
  
  should "get nil from find_from_session_or_params if params and session are empty" do
    params = {}
    session = {}
    
    assert_equal nil, Take.find_from_session_or_params(params, session)
  end
  
  # self.save_from_session_for_user(session, user)
  should "save_from_session_for_user(session, user)" do
    user = User.find(1)
    session = {}
    session[:take] = {:te=>1, :u=>1, :s=>1293196670, :f=>0, :a=>0, :c=>0, :r=>[], :qo=>"1,2"}
    @saved_take = Take.save_from_session_for_user(session, user)
    
    assert_equal @saved_take.user_id, user.id
    assert_equal true, @saved_take.id > 0
  end
  
  should "convert question_order into an array by calling question_ids" do
    @take = Take.find(1)
    assert_equal [1,2], @take.question_ids
  end
  
  should "return an empty array when calling question_ids if there aren't any" do
    @take = Take.find(2)
    puts "@take with now question_order: #{@take.inspect}"
    
    assert_equal [], @take.question_ids
  end
  
end
