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
    @test = Test.find(params[:test_id])
    @question = Question.find(params[:id])
    
    logger.debug "params[:question_number]: #{params[:question_number]}"
    @question_number = (params[:question_number]) ? params[:question_number].to_i : 1
    logger.debug "@question_number: #{@question_number}"
    
    if @question_number == 1
      
      # this is done both here and in TestsController#show. How to dry it up?
      @take = Take.new
      @take.test = @test
      @take.user = current_user
      @take.started_at = Time.now
      @take.save
      
    else
      @take = Take.find(params[:take_id])
    end

    respond_to do |format|
      format.html do
        render :layout => false #if params[:layout] && params[:layout] == 'false'
      end
      format.xml  { render :xml => @question }
    end
  end
  
  def answer
    @test = Test.find(params[:test_id])
    @question = Question.find(params[:question_id])
    @question_number = params[:question_number].to_i
    @take = Take.find(params[:take_id])
    
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
      logger.debug "-------> checking short answer"
      
      # UPDATE this when there can be more than one correct choice for short answer questions
      @response.choice = @question.choices.first
      @response.take = @take
      @response.name = params[:short_answer]
      
      logger.debug "-------> @question.choices: #{@question.choices.inspect}"
      logger.debug "-------> choice simple name: #{@question.choices.first.simple_name}"
      
      @question.choices.first.simple_name
      
      # do we really need to store the simple name, or can we just always generate it when necessary?
      logger.debug "-------> @response.name: #{@response.name}"
      
      # once you can add multiple correct choices, get them all and loop through looking for matches
      
      @response.correct = (Choice.simplify(@response.name) == @question.choices.first.simple_name) ? true : false
      logger.debug "-------> @response.correct: #{@response.correct}"
      
    end
    
    @response.user = current_user
    @response.test = @test
    @response.question = @question
    @response.take = @take
    @response.save
    
    @question.responses << @response
    
    @response_count = @question.responses.size
    logger.debug "@response_count: #{@response_count}"
    @correct_response_count = @question.number_correct
    
    logger.debug "@correct_response_count: #{@correct_response_count}"
    
    @percentage_correct = (@response_count > 0) ? (((@correct_response_count.to_f/@response_count.to_f)*100)+0.5).to_i : 0
    
    if @test.questions.length == @question_number
      @more = false
      @take.finished_at = Time.now
      @take.save
    else
      @more = true
      @question_number = @question_number + 1
    end
    
    render :partial => 'questions/answer'
  end

  # GET /questions/new
  # GET /questions/new.xml
  def new
    @test = Test.find(params[:test_id])
    @question = Question.new
    @title = "New question for '#{@test.name}' - Testeroni"
    @description = "New question for '#{@test.name}' - Testeroni"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
    @test = Test.find(params[:test_id]) if params[:test_id]
  end

  # POST /questions
  # POST /questions.xml
  def create
    @question = Question.new(params[:question])
    @test = Test.find(params[:test_id]) if params[:test_id]
    @question.test = @test
    @question.user = current_user
    
    if params[:question][:correct_response].to_i == Choice::MULTIPLE
      @question.kind = Question::MULTIPLECHOICE
      @question.correct_response = nil
      @saved = @question.save
      
      1.upto(5) do |num|
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
            # redirect_to(@test, :notice => "Question was successfully created. #{self.class.helpers.link_to('Add another.', new_question_path(:test_id => @test.id), :style => 'text-decoration:underline;font-weight:bold;')}")
            redirect_to(test_path(@test, :a => 'a'))
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
    @test = Test.find(params[:test_id]) if params[:test_id]

    respond_to do |format|
      if @question.update_attributes(params[:question])
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
    @question.destroy

    respond_to do |format|
      format.html { redirect_to(test_path(params[:test_id]), :notice => 'Question was permanently deleted.') }
      format.xml  { head :ok }
    end
  end
end
