# coding: utf-8

class QuestionsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show, :answer]

  def update_positions
    question_ids = params[:item_ids].map(&:to_i)
    question_ids_positions = Hash[question_ids.map.with_index.to_a]
    questions = current_user.questions.where(id: question_ids)
    questions.each do |question|
      question.position = question_ids_positions[question.id]
      question.save!
    end
    head :no_content
  end

  def show
    @test = Tst.friendly.find(params[:test_id])
    @owner = true if user_signed_in? && @test.owned_by?(current_user)
    @title = "#{@test.name} - Testeroni"
    @description = "'#{@test.name}' a test on Testeroni.com"

    @question = Question.friendly.find(params[:id])
    # @comment = Comment.new(:commentable_type => @question.class, :commentable_id => @question.id)

    if session[:take_id].present?
      @take = Take.find(session[:take_id])
      @response = Response.where(user: current_user, tst: @test, question: @question, take: @take).first
      @already_taken = Response.where(question: @question, take: @take).present?
    end

    render "tsts/show"
  end


  def answer
    @test = Tst.friendly.find(params[:test_id])
    @question = Question.friendly.find(params[:id])

    # @comment = Comment.new(:commentable_type => @question.class, :commentable_id => @question.id)
    # @take = Take.find_from_session_or_params(params, session)

    if @question.first?
      @take = Take.create!(user: current_user, tst: @test, started_at: Time.now, question_order: @test.questions.pluck(:id))
    elsif session[:take_id].present?
      @take = Take.find(session[:take_id])
    else
      @take = Take.create!(user: current_user, tst: @test, started_at: Time.now, question_order: @test.questions.pluck(:id))
    end

    session[:take_id] = @take.id
    @response = Response.new(user: current_user, tst: @test, question: @question, take: @take)
    # @response.take_id = @take.id if @take.id

    if @question.kind == Question::TRUEFALSE
      @answer = (params[:answer] == 'true') ? 1 : 0
      @response.answer = @answer
      @response.correct = (@answer == @question.correct_response) ? true : false
    elsif @question.kind == Question::MULTIPLECHOICE
      @choice = Choice.find(params[:choice_id])
      @response.choice = @choice
      @response.correct = @choice.correct
    elsif @question.kind == Question::SHORTANSWER
      @response.choice = @question.choices.first
      @response.name = params[:short_answer]
      @response.correct = (Choice.simplify(params[:short_answer]) == @question.choices.first.simple_name) ? true : false
    end
    @response.save!

    @take.questions_answered = @take.questions_answered + 1
    @take.questions_correct = @take.questions_correct + 1 if @response.correct?
    @take.save!

    @response_count = @question.responses.size
    @correct_response_count = @question.number_correct

    @percentage_correct = (@response_count > 0) ? (((@correct_response_count.to_f/@response_count.to_f)*100)+0.5).to_i : 0

    if @question.last?
      @take.finished_at = Time.now
      if user_signed_in?
        record_activity(current_user, Activity::TAKE, @test)
      end
    else
      # @more = true
      @question_ids = @take.question_ids
      # @next_question = Question.friendly.find(@question_ids[params[:question_number].to_i])
      # @next_question_url = question_path(@next_question, :test_id => @test.to_param, :question_number => @next_question_number, :take_id => @take.id)
    end

    @take.save!

    render partial: 'questions/answer'
  end

  def new
    @test = Tst.friendly.find(params[:test_id])
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user

    @question = Question.new
    @title = "New question for '#{@test.name}' - Test"
    @description = "New question for '#{@test.name}' - Test"
  end

  def edit
    @question = Question.friendly.find(params[:id])
    @test = Tst.friendly.find(params[:test_id]) if params[:test_id]
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user

    if @question.kind == Question::SHORTANSWER
      @short_answer = true
    end

    if @question.kind == Question::MULTIPLECHOICE
      @multiple_choice = true
    end
  end

  def create
    @question = Question.new(question_params)
    @test = Tst.friendly.find(params[:test_id]) if params[:test_id]
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
        flash[:notice] = 'Question added'
        redirect_to(test_path(@test, :a => 'a'))
      else
        redirect_to(@question, :notice => 'Question was successfully created.')
      end
    else
      render :action => "new"
    end
  end

  def update
    @question = Question.friendly.find(params[:id])
    @test = Tst.friendly.find(params[:test_id]) if params[:test_id]
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user

    if @question.update(question_params)

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
        redirect_to(edit_test_path(@test), :notice => 'Question was successfully updated.')
      else
        redirect_to(@question, :notice => 'Question was successfully updated.')
      end
    else
      render :action => "edit"
    end
  end

  def update_positions
    question_ids = params[:item_ids].map(&:to_i)
    question_ids_positions = Hash[question_ids.map.with_index.to_a]
    questions = current_user.questions.where(id: question_ids)
    questions.each do |question|
      question.position = question_ids_positions[question.id]
      question.save!
    end
    head :no_content
  end

  def destroy
    @question = Question.friendly.find(params[:id])
    redirect_to root_path and return unless user_signed_in? && @question.user == current_user

    @test = Tst.friendly.find(params[:test_id]) if params[:test_id]

    if @question.destroy
      if @test
        redirect_to(edit_test_path(@test), :notice => 'Question was deleted.')
      else
        redirect_to(root_path, :notice => 'Question was deleted.')
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      # params.require(:tst).permit(:name, :description, :status, :contributors)
      params.require(:question).permit(:name, :description, :status, :hint, :image_url, :explanation, :kind, :correct_response, :pause_at)
    end

end
