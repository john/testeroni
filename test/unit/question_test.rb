require 'test_helper'

class QuestionTest < ActiveSupport::TestCase


  should "return 0 correct for a question with no responses at all" do
    @question = Question.find(1)
    assert_equal 0, @question.number_correct
  end
  
  should "get the correct choice" do
    @question = Question.find(2) # a multiple choice question
    @choice = Choice.find(1) # the predetermined correct choice
    assert_equal @question.correct_choice.id, @choice.id
  end
  
  should "know if a question is multiple choice or not" do
    @question1 = Question.find(1)
    @question2 = Question.find(2)
    @question3 = Question.find(3)
    assert_equal false, @question1.is_multiple_choice
    assert_equal true, @question2.is_multiple_choice
    assert_equal false, @question3.is_multiple_choice
  end
  
  should "know if a question is short answer or not" do
    @question1 = Question.find(1)
    @question2 = Question.find(2)
    @question3 = Question.find(3)
    assert_equal false, @question1.is_short_answer
    assert_equal false, @question2.is_short_answer
    assert_equal true, @question3.is_short_answer
  end
  
  should "get_nonzero_position_in_id_array" do
    ids = [1,2,3]
    @question = Question.find(2)
    pos = @question.get_nonzero_position_in_id_array(ids)
    assert_equal 2, pos
  end

end
