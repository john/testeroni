# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

@user = User.create(:username => 'Testeroni', :password => 'besteroni', :password_confirmation => 'besteroni', :email => 'john@Test.com')
@test = Test.create(:name => 'US State Capitals', :user_id => @user.id, :contributors => Test::ANYONE)

# add questions, choices, responses
@q = Question.create( :name => "What is the capital of Alabama?",
                      :kind => Question::MULTIPLECHOICE,
                      :test => @test,
                      :user => @user)
@qc1 = Choice.create(:name => 'Birmingham', :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => 'Montgomery', :question_id => @q.id, :correct => true)
@qc3 = Choice.create(:name => 'Mobile', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Tuscaloosa', :question_id => @q.id, :correct => false)

@q = Question.create(:name => "What is the capital of Alaska?", :kind => Question::MULTIPLECHOICE, :test => @test, :user => @user)
@qc1 = Choice.create(:name => 'Juneau', :question_id => @q.id, :correct => true)
@qc2 = Choice.create(:name => 'McGrath', :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => 'Anchorage', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Wasilla', :question_id => @q.id, :correct => false)

@q = Question.create(:name => "Is Phoenix the capital of Arizona?", :kind => Question::TRUEFALSE, :test => @test,
:user => @user, :correct_response => true)

@q = Question.create(:name => "What is the capital of Arkansas?", :kind => Question::SHORTANSWER, :test => @test,
:user => @user)
@qc1 = Choice.create(:name => 'Little Rock', :simple_name => 'little rock', :question_id => @q.id, :correct => true)

@q = Question.create(:name => "What is the capital of California?", :kind => Question::MULTIPLECHOICE, :test => @test,
:user => @user)
@qc1 = Choice.create(:name => 'San Francisco', :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => 'Los Angeles', :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => 'San Jose', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Sacremento', :question_id => @q.id, :correct => true)

@q = Question.create(:name => "What is the capital of Colorado?", :kind => Question::SHORTANSWER, :test => @test,
:user => @user)
@qc1 = Choice.create(:name => 'Denver', :simple_name => 'denver', :question_id => @q.id, :correct => true)

@q = Question.create(:name => "What is the capital of Connecticut?", :kind => Question::MULTIPLECHOICE, :test => @test,
:user => @user)
@qc1 = Choice.create(:name => 'Stamford', :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => 'New Haven', :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => 'Hartford', :question_id => @q.id, :correct => true)
@qc4 = Choice.create(:name => 'Norwalk', :question_id => @q.id, :correct => false)

@q = Question.create(:name => "Is Wilmington the capital of Delaware?", :kind => Question::TRUEFALSE, :test => @test,
:user => @user, :correct_response => false)

@test.published_at = Time.now
@test.save



@test = Test.create(:name => 'Characters in Shakespeare', :user_id => @user.id, :contributors => Test::JUSTME)

# add questions, choices, responses
@q = Question.create( :name => "Who is the protagonist of 'Hamlet'?",
                      :kind => Question::SHORTANSWER,
                      :test => @test,
                      :user => @user)
@qc1 = Choice.create(:name => 'Hamlet', :simple_name => 'hamlet', :question_id => @q.id, :correct => true)

@test.published_at = Time.now
@test.save

@test = Test.create(:name => 'The Ultimate Simpsons Trivia Test', :user_id => @user.id, :contributors => Test::ANYONE)
@test.published_at = Time.now
@test.save