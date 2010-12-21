# coding: utf-8

class QuestionsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show, :answer]
  
  # GET /questions
  # GET /questions.xml
  def index
    @questions = Question.all
  end

  # GET /questions/1
  # GET /questions/1.xml
  def show
    @test = Tst.find(params[:test_id])
    @question = Question.find(params[:id])
    
    # to save a lookup pass in question number when practical, but if it's not present, figure it out.
    @question_number = 1
    if params[:question_number]
      @question_number = params[:question_number].to_i
    else
      @test.questions.each_with_index do |q,i|
        if q.id == @question.id
          @question_number = i+1
          break
        end
      end
    end
    
    @comment = Comment.new(:commentable_type => @question.class, :commentable_id => @question.id)

    if user_signed_in?
      if @question_number == 1
        @take = Take.new(:tst_id => @test.id, :user_id => current_user.id, :started_at => Time.now, :questions_answered => 0, :questions_correct => 0)
        @take.save
      else
        @take = Take.find(params[:take_id]) unless params[:take_id].blank?
      end
    elsif session[:take]
      @take = Take.desessionize(session)
    end
    
    if @take
      @next_question_url = question_path(@test.questions[(@question_number-1)], :test_id => @test.to_param, :question_number => @question_number, :take_id => @take.id)
    else
      @next_question_url = question_path(@test.questions[(@question_number-1)], :test_id => @test.to_param, :question_number => @question_number)
    end
    
    render :partial => 'show'
  end
  
  def answer
    @test = Tst.find(params[:test_id])
    @question = Question.find(params[:question_id])
    @question_number = params[:question_number].to_i
    @comment = Comment.new(:commentable_type => @question.class, :commentable_id => @question.id)
    
    if user_signed_in?
      # if user is signed in, a take was previously created
      @take = Take.find(params[:take_id])
    elsif session[:take] && @question_number > 1
      # if they're not signed in and it's not the first question, get from session
      @take = Take.desessionize(session)
    else
      # they're not signed in and just starting, so create object to put in session
      @take = Take.new(:tst_id => @test.id, :started_at => Time.now, :questions_answered => 0, :questions_correct => 0)
    end
    
    @response = Response.new(:tst_id => @test.id, :question_id => @question.id)
    @response.take_id = @take.id if @take.id
    
    if !params[:answer].blank?
      @answer = (params[:answer] == 'true') ? 1 : 0
      @response.answer = @answer
      @response.correct = (@answer == @question.correct_response) ? true : false
    elsif !params[:choice_id].blank?
      @choice = Choice.find(params[:choice_id])
      @response.choice = @choice
      @response.correct = @choice.correct
    elsif !params[:short_answer].blank?
      @response.choice = @question.choices.first
      @response.name = params[:short_answer]
      @response.correct = (Choice.simplify(params[:short_answer]) == @question.choices.first.simple_name) ? true : false
    end
    
    @take.questions_answered = @take.questions_answered+1
    @take.questions_correct = @take.questions_correct+1 if @response.correct?
    
    # might be able to get rid of this now that it's a Take through and through
    @questions_answered = @take.questions_answered
    @questions_correct = @take.questions_correct
    
    if user_signed_in?
      @response.user = current_user
      @response.take = @take
      @response.save
      @question.responses << @response
      
      @response_count = @question.responses.size
      @correct_response_count = @question.number_correct
    else
      @take.responses << @response
      session[:take] = @take.sessionize
      
      @response_count = @question.responses.size + 1
      @correct_response_count = (@response.correct?) ? @question.number_correct+1 : @question.number_correct
    end
    
    
    
    @percentage_correct = (@response_count > 0) ? (((@correct_response_count.to_f/@response_count.to_f)*100)+0.5).to_i : 0
    
    if @test.questions.length == @question_number
      @more = false
      @take.finished_at = Time.now if params[:take_id]
      session[:take] = @take.sessionize
    else
      @more = true
      @question_number = @question_number + 1
    end
    
    @take.save if @take.id
    
    render :partial => 'questions/answer'
  end

  def new
    @test = Tst.find(params[:test_id])
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user
    
    @question = Question.new
    @title = "New question for '#{@test.name}' - Test"
    @description = "New question for '#{@test.name}' - Test"
  end

  def edit
    @question = Question.find(params[:id])
    @test = Tst.find(params[:test_id]) if params[:test_id]
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user
    
    if @question.kind == Question::SHORTANSWER
      @short_answer = true
    end
    
    if @question.kind == Question::MULTIPLECHOICE
      @multiple_choice = true
    end
  end

  # POST /questions
  # POST /questions.xml
  def create
    @question = Question.new(params[:question])
    @test = Tst.find(params[:test_id]) if params[:test_id]
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user
    
    @question.tst = @test
    @question.user = current_user
    
    if params[:question][:correct_response].to_i == Choice::MULTIPLE
      @question.kind = Question::MULTIPLECHOICE
      @question.correct_response = nil
      @saved = @question.save
      
      # TODO: Dry this; it's repeated in 'update'
      1.upto(Choice::MAX_ALLOWED_CHOICES) do |num|
        @choice = Choice.new
        @choice.question = @question
        @choice.name = params["choice_#{num}".to_sym]
        @choice.correct = (params[:correct_answer] == "choice_#{num}") ? true : false
        @choice.save
      end
    elsif params[:question][:correct_response].to_i == Choice::SHORT
      @question.kind = Question::SHORTANSWER
      @question.correct_response = nil
      @saved = @question.save
      
      @choice = Choice.new
      @choice.question = @question
      @choice.name = params[:short_answer]
      @choice.simple_name = Choice.simplify(@choice.name)
      @choice.correct = true
      @choice.save
    else
      @question.kind = Question::TRUEFALSE
      @saved = @question.save
    end
    
    if @saved
      if @test
        redirect_to(test_path(@test.id, @test.to_param, :a => 'a'))
      else
        redirect_to(@question, :notice => 'Question was successfully created.')
      end
    else
      render :action => "new"
    end
  end

  def update
    @question = Question.find(params[:id])
    @test = Tst.find(params[:test_id]) if params[:test_id]
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user

    if @question.update_attributes(params[:question])
      
      # handle short answer
      if @question.kind == Question::SHORTANSWER
        @choice = @question.choices.first
        @choice.name = params[:short_answer]
        @choice.simple_name = Choice.simplify(params[:short_answer])
        @choice.save
      end
      
      # handle multiple choice
      params.each do |param|
        if param[0].include?('choiceupdate_')
          choice = Choice.find(param[0].split('_')[1])
          choice.name = param[1]
          choice.correct = (params[:correct_answer] == param[0]) ? true : false
          choice.save
        end
      end
      
      if @test
        redirect_to(@test, :notice => 'Question was successfully updated.')
      else
        redirect_to(@question, :notice => 'Question was successfully updated.')
      end
    else
      render :action => "edit"
    end
  end

  def destroy
    @question = Question.find(params[:id])
    redirect_to root_path and return unless user_signed_in? && @question.user == current_user
    
    @question.destroy
    redirect_to(test_path(params[:test_id]), :notice => 'Question was permanently deleted.')
  end
end
