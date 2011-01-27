# coding: utf-8

class QuestionsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show, :answer]

  def show
    @test = Tst.find(params[:test_id])
    @take = Take.find_from_session_or_params(params, session)
    
    # if params[:randomize] # this is only ever passed in when it's the start of a test
    #   @question_ids = @test.questions.collect{|q| q.id}.shuffle
    #   # @question_ids.delete(@question.id)
    #   @question = Question.find(@question_ids[0])
    # else
    #   @question_ids = (@take.nil?) ? @test.questions.collect{|q| q.id} : @take.question_ids
    #   @question = Question.find(params[:id])
    # end
    
    @question_ids = @take.question_ids
    @question = Question.find(params[:id])
    
    logger.debug "IN QUESTION#SHOW, @question_ids: #{@question_ids.inspect}"
    
    # @comment = Comment.new(:commentable_type => @question.class, :commentable_id => @question.id)

    # if @take.nil?
    #   @take = Take.new( :tst_id => @test.id,
    #                     :user_id => (user_signed_in?) ? current_user.id : nil,
    #                     :started_at => Time.now,
    #                     :questions_answered => 0,
    #                     :questions_correct => 0,
    #                     :question_order => @question_ids.join(',') )
    #   (user_signed_in?) ? @take.save : session[:take] = @take.sessionize
    # end
    
    # to save a lookup pass in the question number when practical, but if it's not present, figure it out.
    if params[:question_number]
      @question_number = params[:question_number].to_i
    else
      @question_number = @question.get_nonzero_position_in_id_array(@question_ids)      
    end
    
    render :partial => 'show'
  end
  
  def answer
    @test = Tst.find(params[:test_id])
    
    @question = Question.find(params[:question_id])
    @question_number = params[:question_number].to_i
    @comment = Comment.new(:commentable_type => @question.class, :commentable_id => @question.id)
    @take = Take.find_from_session_or_params(params, session)
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
    
    if user_signed_in?
      @response.user = current_user
      @response.take = @take
      @response.save
      @question.responses << @response
      @response_count = @question.responses.size
      @correct_response_count = @question.number_correct
    else
      @response.save
      @take.responses << @response
      session[:take] = @take.sessionize
      @response_count = @question.responses.size + 1
      @correct_response_count = (@response.correct?) ? @question.number_correct+1 : @question.number_correct
    end
    @percentage_correct = (@response_count > 0) ? (((@correct_response_count.to_f/@response_count.to_f)*100)+0.5).to_i : 0
    
    if @test.questions.length == @question_number
      @more = false
      @take.finished_at = Time.now if params[:take_id]
      if user_signed_in?
        record_activity(current_user, Activity::TAKE, @test)
      else
        session[:take] = @take.sessionize
      end
    else
      @more = true
      @question_number = @question_number + 1
    end
    @take.save if user_signed_in?
    
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
