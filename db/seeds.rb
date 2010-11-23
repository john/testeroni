# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

@user = User.create(:username => 'Testeroni', :password => 'bester0n1', :password_confirmation => 'bester0n1', :email => 'john@testeroni.com')
@test = Test.create(:name => 'US State Capitals', :user_id => @user.id)

# add questions, choices, responses
@q = Question.create( :name => "What is the capital of Alabama?",
                      :kind => Question::MULTIPLECHOICE,
                      :test_id => @test.id,
                      :user_id => @user.id)
@qc1 = Choice.create(:name => 'Birhmingham', :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => 'Montgomery', :question_id => @q.id, :correct => true)
@qc3 = Choice.create(:name => 'Mobile', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Tuscaloosa', :question_id => @q.id, :correct => false)

@q = Question.create(:name => "What is the capital of Alaska?", :kind => Question::MULTIPLECHOICE, :test_id => @test.id, :user_id => @user.id)
@qc1 = Choice.create(:name => 'Juneau', :question_id => @q.id, :correct => true)
@qc2 = Choice.create(:name => 'McGrath', :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => 'Anchorage', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Wasilla', :question_id => @q.id, :correct => false)

@test.published_at = Time.now
@test.save