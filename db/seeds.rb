# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

@user = User.create(:display_name => 'Testeroni', :password => 'besteroni', :password_confirmation => 'besteroni', :email => 'john@testeroni.com')
@user2 = User.create(:display_name => 'resteroni', :password => 'noodle', :password_confirmation => 'noodle', :email => 'john@resteroni.com')

# @test = Tst.create(:name => 'How Much Do You Really Know About McDonalds?',
#                     :user_id => @user2.id,
#                     :contributors => Tst::ANYONE,
#                     :status => Tst::ACTIVE)
# @test.published_at = Time.now
# @test.save

@test = Tst.create(:name => 'US State Capitals',
                    :description => "Test your knowledge of US geography with this test about state capitals.",
                    :user_id => @user.id,
                    :contributors => Tst::ANYONE,
                    :status => Tst::ACTIVE)
@test.tag_list = "U.S., geography, states, capitals"
# add questions, choices, responses
@q = Question.create( :name => "What is the capital of Alabama?",
                      :kind => Question::MULTIPLECHOICE,
                      :tst => @test,
                      :user => @user)
@qc1 = Choice.create(:name => 'Birmingham', :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => 'Montgomery', :question_id => @q.id, :correct => true)
@qc3 = Choice.create(:name => 'Mobile', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Tuscaloosa', :question_id => @q.id, :correct => false)

@q = Question.create(:name => "What is the capital of Alaska?", :kind => Question::MULTIPLECHOICE, :tst => @test, :user => @user)
@qc1 = Choice.create(:name => 'Juneau', :question_id => @q.id, :correct => true)
@qc2 = Choice.create(:name => 'McGrath', :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => 'Anchorage', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Wasilla', :question_id => @q.id, :correct => false)

@q = Question.create(:name => "Is Phoenix the capital of Arizona?", :kind => Question::TRUEFALSE, :tst => @test,
:user => @user, :correct_response => true, :explanation => 'The capital of Arizona is Phoenix.')

@q = Question.create(:name => "What is the capital of Arkansas?", :kind => Question::SHORTANSWER, :tst => @test,
:user => @user)
@qc1 = Choice.create(:name => 'Little Rock', :simple_name => 'little rock', :question_id => @q.id, :correct => true)

@q = Question.create(:name => "What is the capital of California?", :kind => Question::MULTIPLECHOICE, :tst => @test,
:user => @user)
@qc1 = Choice.create(:name => 'San Francisco', :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => 'Los Angeles', :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => 'San Jose', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Sacremento', :question_id => @q.id, :correct => true)

@q = Question.create(:name => "What is the capital of Colorado?", :kind => Question::SHORTANSWER, :tst => @test,
:user => @user)
@qc1 = Choice.create(:name => 'Denver', :simple_name => 'denver', :question_id => @q.id, :correct => true)

@q = Question.create(:name => "What is the capital of Connecticut?", :kind => Question::MULTIPLECHOICE, :tst => @test,
:user => @user)
@qc1 = Choice.create(:name => 'Stamford', :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => 'New Haven', :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => 'Hartford', :question_id => @q.id, :correct => true)
@qc4 = Choice.create(:name => 'Norwalk', :question_id => @q.id, :correct => false)

@q = Question.create(:name => "Is Wilmington the capital of Delaware?", :kind => Question::TRUEFALSE, :tst => @test,
:user => @user, :correct_response => false, :explanation => 'The capital of Delaware is Dover.')

@q = Question.create(:name => "What Florida city, and state capital, is pictured here?", :image_url => 'http://3.bp.blogspot.com/_SNSoiGhOsCY/TLcMn-4E_eI/AAAAAAAAAH0/-ZTiAJjoFPo/s400/A-Tidal-Wave-Of-Distressed-Properties-In-The-Tallahassee-Real-Estate-Market.jpg',
:kind => Question::MULTIPLECHOICE, :tst => @test, :user => @user)
@qc1 = Choice.create(:name => 'Tallahassee', :question_id => @q.id, :correct => true)
@qc2 = Choice.create(:name => 'Miami', :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => 'Pensicola', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Chad', :question_id => @q.id, :correct => false)


@test.published_at = Time.now
@test.save

@test = Tst.create(:name => 'Characters in Shakespeare', :user_id => @user.id, :contributors => Tst::JUSTME, :status => Tst::ACTIVE)
@test.tag_list = "Shakespeare, literature, english, drama"

# add questions, choices, responses
@q = Question.create( :name => "Who is the protagonist of 'Hamlet'?",
                      :kind => Question::SHORTANSWER,
                      :tst => @test,
                      :user => @user)
@qc1 = Choice.create(:name => 'Hamlet', :simple_name => 'hamlet', :question_id => @q.id, :correct => true)

@test.published_at = Time.now
@test.save

@test = Tst.create(:name => 'The Ultimate Simpsons Trivia Test', :user_id => @user.id, :contributors => Tst::ANYONE, :status => Tst::ACTIVE)
@test.tag_list = "Simpsons, Matt Groening, animation, tv, pop culture"
@test.published_at = Time.now
@test.save

@test = Tst.create(:name => 'U.S. Presidents', :user_id => @user.id, :contributors => Tst::ANYONE, :status => Tst::ACTIVE)
@test.tag_list = "United States, history, presidents"
@test.published_at = Time.now
@test.save

@test = Tst.create(:name => 'Shatner', :user_id => @user.id, :contributors => Tst::ANYONE, :status => Tst::ACTIVE)
@test.tag_list = "Shatner, pop culture"
@test.published_at = Time.now
@test.save

@test = Tst.create(:name => 'What does it all mean?', :user_id => @user.id, :contributors => Tst::ANYONE, :status => Tst::ACTIVE)
@test.tag_list = "words, language, games"
@test.published_at = Time.now
@test.save

@test = Tst.create(:name => 'Nobel Prize winners', :user_id => @user.id, :contributors => Tst::ANYONE, :status => Tst::ACTIVE)
@test.tag_list = "Nobel, prizes, history"
@test.published_at = Time.now
@test.save

@test = Tst.create(:name => 'Oscar winners', :user_id => @user.id, :contributors => Tst::ANYONE, :status => Tst::ACTIVE)
@test.tag_list = "Oscars, prizes, movies, pop culture, history"
@test.published_at = Time.now
@test.save

@test.published_at = Time.now
@test.save