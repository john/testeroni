@user = User.create(:name => 'John', :password => '1234abcd', :password_confirmation => '1234abcd', :email => 'john@fnnny.com')
@user2 = User.create(:name => 'Kristy', :password => '1234abcd', :password_confirmation => '1234abcd', :email => 'kristina.a.dahl@gmail.com')

###### MCDONALDS ####
@test = Tst.create(:name => 'How Much Do You Really Know About McDonalds?',
                    :user_id => @user2.id, :contributors => Tst::ANYONE, :status => Tst::ACTIVE)
@test.published_at = Time.now
@test.save

###### STATE CAPITALS ####
@test = Tst.create( :name => 'US State Capitals',
                    :description => "Test your knowledge of US geography with this test about state capitals.",
                    :user_id => @user.id, :contributors => Tst::ANYONE, :status => Tst::ACTIVE)
# @test.tag_list = "U.S., geography, states, capitals"

@q = Question.create( :name => "What is the capital of Alabama?", :kind => Question::MULTIPLECHOICE, :tst => @test, :user => @user, :explanation => 'The capital of Alabama is Montgomery.')
@qc1 = Choice.create(:name => 'Birmingham', :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => 'Montgomery', :question_id => @q.id, :correct => true)
@qc3 = Choice.create(:name => 'Mobile', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Tuscaloosa', :question_id => @q.id, :correct => false)

@q = Question.create(:name => "What is the capital of Alaska?", :kind => Question::MULTIPLECHOICE, :tst => @test, :user => @user, :explanation => 'The capital of Alaska is Juneau.')
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
:user => @user, :explanation => 'The capital of  is .')
@qc1 = Choice.create(:name => 'San Francisco', :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => 'Los Angeles', :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => 'San Jose', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Sacremento', :question_id => @q.id, :correct => true)

@q = Question.create(:name => "What is the capital of Colorado?", :kind => Question::SHORTANSWER, :tst => @test,
:user => @user, :explanation => 'The capital of Colorado is Denver.')
@qc1 = Choice.create(:name => 'Denver', :simple_name => 'denver', :question_id => @q.id, :correct => true)

@q = Question.create(:name => "What is the capital of Connecticut?", :kind => Question::MULTIPLECHOICE, :tst => @test,
:user => @user, :explanation => 'The capital of Connecticut is Hartford.')
@qc1 = Choice.create(:name => 'Stamford', :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => 'New Haven', :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => 'Hartford', :question_id => @q.id, :correct => true)
@qc4 = Choice.create(:name => 'Norwalk', :question_id => @q.id, :correct => false)

@q = Question.create(:name => "Is Wilmington the capital of Delaware?", :kind => Question::TRUEFALSE, :tst => @test,
:user => @user, :correct_response => false, :explanation => 'The capital of Delaware is Dover.')

@q = Question.create(:name => "What Florida city, and state capital, is pictured here?", :image_url => 'http://3.bp.blogspot.com/_SNSoiGhOsCY/TLcMn-4E_eI/AAAAAAAAAH0/-ZTiAJjoFPo/s400/A-Tidal-Wave-Of-Distressed-Properties-In-The-Tallahassee-Real-Estate-Market.jpg',
:kind => Question::MULTIPLECHOICE, :tst => @test, :user => @user, :explanation => 'The capital of Florida is Tallahassee.')
@qc1 = Choice.create(:name => 'Tallahassee', :question_id => @q.id, :correct => true)
@qc2 = Choice.create(:name => 'Miami', :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => 'Pensicola', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Chad', :question_id => @q.id, :correct => false)

@q = Question.create(:name => "What is the capital of Georgia?", :kind => Question::SHORTANSWER, :tst => @test,
:user => @user, :explanation => 'The capital of Georgia is Atlanta.')
@qc1 = Choice.create(:name => 'Atlanta', :simple_name => 'atlanta', :question_id => @q.id, :correct => true)

@q = Question.create(:name => "Is Honolulu the capital of Hawaii?", :kind => Question::TRUEFALSE, :tst => @test,
:user => @user, :correct_response => false, :explanation => 'The capital of Hawaii is Honolulu.')

@q = Question.create(:name => "What is the capital of Idaho?",
    :image_url => 'http://en.wikipedia.org/wiki/File:Russet_potato_cultivar_with_sprouts.jpg',
    :kind => Question::MULTIPLECHOICE, :tst => @test, :user => @user, :explanation => "The capital of Idaho is Boise. Helena isn't even in Idaho--it's the capital of Montana. And Russett isn't a place at all. It's a potato.")
@qc1 = Choice.create(:name => 'Twin Falls', :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => 'Boise', :question_id => @q.id, :correct => true)
@qc3 = Choice.create(:name => 'Helena', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Russett', :question_id => @q.id, :correct => false)

@q = Question.create(:name => "What is the capital of Illinois?",
    :image_url => 'http://www.8notes.com/wiki/images/300px-BluesBrothers.jpg',
    :kind => Question::MULTIPLECHOICE, :tst => @test, :user => @user, :explanation => 'Springfield is both the home of the Simpsons, and the capital of Illinois.')
@qc1 = Choice.create(:name => 'Joliet', :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => 'Chicago', :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => 'Rockfield', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Springfield', :question_id => @q.id, :correct => true)

@test.published_at = Time.now
@test.save

###### SHAKESPEARE CHARACTERS ####
@test = Tst.create(:name => 'Characters in Shakespeare', :user_id => @user.id, :contributors => Tst::JUSTME, :status => Tst::ACTIVE)
# @test.tag_list = "Shakespeare, literature, english, drama"

@q = Question.create( :name => "Who is the protagonist of 'Hamlet'?",:kind => Question::SHORTANSWER, :tst => @test,:user => @user)
@qc1 = Choice.create(:name => 'Hamlet', :simple_name => 'hamlet', :question_id => @q.id, :correct => true)

@test.published_at = Time.now
@test.save

###### CLIMATE CHANGE ####
@test = Tst.create(:name => 'Facts About Climate Change', :user_id => @user.id, :contributors => Tst::JUSTME, :status => Tst::ACTIVE)
# @test.tag_list = "climate, climate change, science"
@test.published_at = Time.now
@test.save

###### SIMPSONS ####
@test = Tst.create(:name => 'The Ultimate Simpsons Trivia Test', :user_id => @user.id, :contributors => Tst::ANYONE, :status => Tst::ACTIVE)
# @test.tag_list = "Simpsons, Matt Groening, animation, tv, pop culture"

@q = Question.create( :name => "What is the origin of Maggie's pacifier?",:kind => Question::MULTIPLECHOICE, :tst => @test,:user => @user,
        :hint => "This was revealed after Homer told the story about Lisa's saxaphone.")
@qc1 = Choice.create(:name => 'Came free with cradle', :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => 'Bought at a store for $1.95', :question_id => @q.id, :correct => true)
@qc3 = Choice.create(:name => 'Homer bought it thinking it was a dog toy.', :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => 'Christmas present from Patty and Selma', :question_id => @q.id, :correct => false)

@q = Question.create( :name => "Who was the musical guest on Krusty's Komeback Special?",:kind => Question::MULTIPLECHOICE, :tst => @test,:user => @user,
        :hint => "Johnny Carson also sings opera in this episode.")
@qc1 = Choice.create(:name => "Cypress Hill", :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => "ZZ Top", :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => "The Red Hot Chili Peppers", :question_id => @q.id, :correct => true)
@qc4 = Choice.create(:name => "Kid Rock", :question_id => @q.id, :correct => false)

@q = Question.create( :name => 'When Lisa tried to do a story for "Kidz News", what was the crazy woman throwing at her?',:kind => Question::MULTIPLECHOICE, :tst => @test,:user => @user,
        :hint => "Lisa was trying to do a sympathy story. The answer is not C.")
@qc1 = Choice.create(:name => "Cats", :question_id => @q.id, :correct => true)
@qc2 = Choice.create(:name => "Bottles", :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => "Dinner Plates", :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => "Mud", :question_id => @q.id, :correct => false)

@q = Question.create( :name => "What is Police Chief Wiggum's first name?",:kind => Question::MULTIPLECHOICE, :tst => @test,:user => @user,
        :hint => 'The answer does not end with "arl".')
@qc1 = Choice.create(:name => "Carl", :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => "Clem", :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => "Clark", :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => "Clancy", :question_id => @q.id, :correct => true)

@q = Question.create( :name => 'Who said "Something\'s rotten at the Simpson house!"?',:kind => Question::MULTIPLECHOICE, :tst => @test,:user => @user,
        :hint => "This was the episode when Homer and Marge lost Bart, Lisa and Maggie.")
@qc1 = Choice.create(:name => "Carl", :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => "Principal Skinner", :question_id => @q.id, :correct => true)
@qc3 = Choice.create(:name => "Billy Corgan", :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => "Krusty the Clown", :question_id => @q.id, :correct => false)

@q = Question.create( :name => "What is Mr. Smithers' first name?",:kind => Question::MULTIPLECHOICE, :tst => @test,:user => @user,
        :hint => "The answer is not C.")
@qc1 = Choice.create(:name => "John", :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => "Waylon", :question_id => @q.id, :correct => true)
@qc3 = Choice.create(:name => "Andrew", :question_id => @q.id, :correct => false)
@qc4 = Choice.create(:name => "Blair", :question_id => @q.id, :correct => false)

# @q = Question.create( :name => "",:kind => Question::MULTIPLECHOICE, :tst => @test,:user => @user,
#         :hint => "")
# @qc1 = Choice.create(:name => "", :question_id => @q.id, :correct => false)
# @qc2 = Choice.create(:name => "", :question_id => @q.id, :correct => true)
# @qc3 = Choice.create(:name => "", :question_id => @q.id, :correct => false)
# @qc4 = Choice.create(:name => "", :question_id => @q.id, :correct => false)

@test.published_at = Time.now
@test.save

###### PRESIDENTS ####
@test = Tst.create(:name => 'U.S. Presidents', :user_id => @user.id, :contributors => Tst::ANYONE, :status => Tst::ACTIVE)
# @test.tag_list = "United States, history, presidents"
@test.published_at = Time.now
@test.save

###### SHATNER ####
@test = Tst.create(:name => 'Shatner', :user_id => @user.id, :contributors => Tst::ANYONE, :status => Tst::ACTIVE)
# @test.tag_list = "Shatner, pop culture"
@test.published_at = Time.now
@test.save

###### WORD DEFINITIONS ####
@test = Tst.create(:name => 'What does it all mean?', :user_id => @user.id, :contributors => Tst::ANYONE, :status => Tst::ACTIVE)
# @test.tag_list = "words, language, games"
@test.published_at = Time.now
@test.save

###### NOBEL WINNERS ####
@test = Tst.create(:name => 'Nobel Prize winners', :user_id => @user.id, :contributors => Tst::ANYONE, :status => Tst::ACTIVE)
# @test.tag_list = "Nobel, prizes, history"

@q = Question.create(:name => "Which of these people did not win a Nobel Prize?", :kind => Question::MULTIPLECHOICE, :tst => @test, :user => @user,
            :explanation => 'This is kind of a trick question, in that Sartre was awarded the prize, but refused it. Kissinger won in 1973, Obama in 2009. Gandhi was nominated five times, but never won.')
@qc1 = Choice.create(:name => 'Henry Kissinger', :question_id => @q.id, :correct => false)
@qc2 = Choice.create(:name => 'Barack Obama', :question_id => @q.id, :correct => false)
@qc3 = Choice.create(:name => 'Mohandas Gandhi', :question_id => @q.id, :correct => true)
@qc4 = Choice.create(:name => 'Jean Paul Sartre', :question_id => @q.id, :correct => false)

@test.published_at = Time.now
@test.save

###### OSCAR WINNERS ####
@test = Tst.create(:name => 'Oscar winners', :user_id => @user.id, :contributors => Tst::ANYONE, :status => Tst::ACTIVE)
# @test.tag_list = "Oscars, prizes, movies, pop culture, history"
@test.published_at = Time.now
@test.save

@test.published_at = Time.now
@test.save
