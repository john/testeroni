# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

@user = User.create(:username => 'Testeroni', :password => 'besteroni', :password_confirmation => 'besteroni', :email => 'john@testeroni.com')
@test = Test.create(:name => 'US State Capitals', :user_id => @user.id)

# add questions, choices, responses
@q = Question.create( :name => "What is the capital of Alabama?",
                      :kind => Question::MULTIPLECHOICE,
                      :test_id => @test.id,
                      :user_id => @user.id)
@qc1 = Choice.create(:name => 'Birmingham', :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => 'Montgomery', :question_id => @q.id, :correct => true)
@qc3 = Choice.create(:name => 'Mobile', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Tuscaloosa', :question_id => @q.id, :correct => false)

@q = Question.create(:name => "What is the capital of Alaska?", :kind => Question::MULTIPLECHOICE, :test_id => @test.id, :user_id => @user.id)
@qc1 = Choice.create(:name => 'Juneau', :question_id => @q.id, :correct => true)
@qc2 = Choice.create(:name => 'McGrath', :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => 'Anchorage', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Wasilla', :question_id => @q.id, :correct => false)

@q = Question.create(:name => "Is Phoenix the capital of Arizona?", :kind => Question::TRUEFALSE, :test_id => @test.id, :user_id => @user.id, :correct_response => true)

@q = Question.create(:name => "What is the capital of Arkansas?", :kind => Question::SHORTANSWER, :test_id => @test.id, :user_id => @user.id)
@qc1 = Choice.create(:name => 'Little Rock', :simple_name => 'little rock', :question_id => @q.id, :correct => true)

@test.published_at = Time.now
@test.save



@test = Test.create(:name => 'Characters in Shakespeare', :user_id => @user.id)

# add questions, choices, responses
@q = Question.create( :name => "Who is the protagonist of 'Hamlet'?",
                      :kind => Question::SHORTANSWER,
                      :test_id => @test.id,
                      :user_id => @user.id)
@qc1 = Choice.create(:name => 'Hamlet', :simple_name => 'hamlet', :question_id => @q.id, :correct => true)

@test.published_at = Time.now
@test.save