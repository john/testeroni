# coding: utf-8

class QuestionsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show, :answer]
  
  # GET /questions
  # GET /questions.xml
  def index
    @questions = Question.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.xml
  def show
    @test = Tst.find(params[:test_id])
    @question = Question.find(params[:id])
    @question_number = (params[:question_number]) ? params[:question_number].to_i : 1
    @comment = Comment.new(:commentable_type => @question.class, :commentable_id => @question.id)

    if @question_number == 1
      @take = Take.new
      @take.questions_answered = 0
      @take.questions_correct = 0
      @take.tst = @test
      @take.user = current_user
      @take.started_at = Time.now
      @take.save
    else
      @take = Take.find(params[:take_id])
    end

    respond_to do |format|
      format.html do
        render :partial => 'show'
      end
      format.xml  { render :xml => @question }
    end
  end
  
  def answer
    @test = Tst.find(params[:test_id])
    @question = Question.find(params[:question_id])
    @question_number = params[:question_number].to_i
    @comment = Comment.new(:commentable_type => @question.class, :commentable_id => @question.id)
    
    @response = Response.new
    if params[:answer]
      @answer = (params[:answer] == 'true') ? 1 : 0
      @response.answer = @answer
      @response.take = @take
      @response.correct = (@answer == @question.correct_response) ? true : false
    end
    if params[:choice_id]
      # figure out if they answered correctly
      @choice = Choice.find(params[:choice_id])
      @response.choice = @choice
      @response.correct = @choice.correct
    end
    if params[:short_answer]
      # UPDATE this when there can be more than one correct choice for short answer questions
      @response.choice = @question.choices.first
      @response.take = @take
      @response.name = params[:short_answer]
      @question.choices.first.simple_name

      # once you can add multiple correct choices, get them all and loop through looking for matches
      
      @response.correct = (Choice.simplify(@response.name) == @question.choices.first.simple_name) ? true : false
    end
    
    @take = Take.find(params[:take_id])
    @take.questions_answered = @take.questions_answered+1
    @take.questions_correct = @take.questions_correct+1 if @response.correct?
    
    # if user isn't logged in, memoize the Take object to the session for saving later.
    
    @response.user = current_user
    @response.tst = @test
    @response.question = @question
    @response.take = @take
    @response.save
    
    @question.responses << @response
    
    @response_count = @question.responses.size
    @correct_response_count = @question.number_correct
    @percentage_correct = (@response_count > 0) ? (((@correct_response_count.to_f/@response_count.to_f)*100)+0.5).to_i : 0
    
    if @test.questions.length == @question_number
      @more = false
      @take.finished_at = Time.now
    else
      @more = true
      @question_number = @question_number + 1
    end
    
    @take.save
    
    render :partial => 'questions/answer'
  end

  # GET /questions/new
  # GET /questions/new.xml
  def new
    @test = Tst.find(params[:test_id])
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user
    
    @question = Question.new
    @title = "New question for '#{@test.name}' - Test"
    @description = "New question for '#{@test.name}' - Test"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/1/edit
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
    
    respond_to do |format|
      if @saved
        format.html do
          if @test
            redirect_to(test_path(@test.id, @test.to_param, :a => 'a'))
          else
            redirect_to(@question, :notice => 'Question was successfully created.')
          end
        end
        format.xml  { render :xml => @question, :status => :created, :location => @question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.xml
  def update
    @question = Question.find(params[:id])
    @test = Tst.find(params[:test_id]) if params[:test_id]
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user

    respond_to do |format|
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
        
        format.html do
          if @test
            redirect_to(@test, :notice => 'Question was successfully updated.')
          else
            redirect_to(@question, :notice => 'Question was successfully updated.')
          end
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.xml
  def destroy
    @question = Question.find(params[:id])
    redirect_to root_path and return unless user_signed_in? && @question.user == current_user
    
    @question.destroy

    respond_to do |format|
      format.html { redirect_to(test_path(params[:test_id]), :notice => 'Question was permanently deleted.') }
      format.xml  { head :ok }
    end
  end
end
