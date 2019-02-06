# coding: utf-8

class TstsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show, :comments]

  def index
    @tests = Tst.all
    @title = "Make and take surveys and tests on Testeroni"
    @description = "Make and take surveys and tests on Testeroni.com"
  end

  def show
    @test = Tst.friendly.find(params[:id])
    @owner = true if user_signed_in? && @test.owned_by?(current_user)
    @title = "#{@test.name} - Testeroni"
    @description = "'#{@test.name}' a test on Testeroni.com"
    # @comment = Comment.new(:commentable_type => @test.class, :commentable_id => @test.id)

    if @test.questions.present?
      @question_ids = @test.questions.collect{|q| q.id}.shuffle
      @question = Question.find(@question_ids[0])
      @take = Take.new( :tst_id => @test.id,
                        :user_id => (user_signed_in?) ? current_user.id : nil,
                        :started_at => Time.now,
                        :questions_answered => 0,
                        :questions_correct => 0,
                        :question_order => @question_ids.join(',') )
    end

    if @take.present?
      if user_signed_in?
        @take.save
      else
        session[:take] = @take.sessionize
      end
    end

    if @test.questions.present? && @question_ids.size > 1
      @next_question = Question.find(@question_ids[1])
      @next_question_url = question_path(@next_question, :test_id => @test.to_param, :question_number => 2)
    end

    # render :layout => 'embed' if request.path =~ /embed/
  end

  def new

    # god there are better ways to do this
    redirect_to root_path and return unless user_signed_in?

    @test = Tst.new(:contributors => Tst::ANYONE)

    @title = "Create a new test or survey on Testeroni"
    @description = "Create a new test or survey on Testeroni.com"
  end

  def edit
    @test = Tst.find(params[:id])
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user
  end

  def create
    @test = Tst.new(tst_params)
    @test.status = Tst::ACTIVE
    @test.user = current_user
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user

    if @test.video_url
      @video = Video.new
      @video.url = @test.video_url
      @video.tst = @test
      # enter video name? get it from YouTube?

      @video.provider_id = @video.get_provider_id_from_url
      @video.save
    end

    logger.debug "-----------------> @test: #{@test.inspect}"

    out = @test.save

    if @test.save
      record_activity(current_user, Activity::CREATE, @test)
      redirect_to( new_question_path(:test_id => @test.id), :notice => 'Test was successfully created.')
    else
      render :action => "new"
    end
  end

  def publish
    @test = Tst.find(params[:id])
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user

    @test.published_at = Time.now
    @test.save

    # if @token = current_user.facebook_token
    #   logger.debug "@token: #{@token}"
    #   @graph = Koala::Facebook::GraphAPI.new(@token)
    #   logger.debug "@graph: #{@graph.inspect}"
    #   @friends = @graph.get_connections("me", "friends").sort{|a,b| a['name'] <=> b['name']}
    # end
    # flash[:notice]

    flash[:notice] = 'Congratulations, your test has been published and can now be taken.'

    @owner = true if user_signed_in? && @test.owned_by?(current_user)
    @title = "#{@test.name} - Testeroni"
    @description = "'#{@test.name}' a test on Testeroni.com"
    @comment = Comment.new(:commentable_type => @test.class, :commentable_id => @test.id)

    @question_number = 1
    if params[:question_id]
      @question = Question.find(params[:question_id])

      # is there a way to get the question_number without having to loop?
      @test.questions.each_with_index do |q, i|
        if q.id == @question.id
          @question_number = i+1
          break
        end
      end
    end

    @next_question_url = question_path(@test.questions[(@question_number-1)], :test_id => @test.to_param, :question_number => @question_number)

    render :template => 'tsts/show'
  end

  def enable
    @test = Tst.find(params[:id])
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user

    @test.status = Tst::ACTIVE
    @test.save
    redirect_to :back
  end

  def disable
    @test = Tst.find(params[:id])
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user

    @test.status = Tst::DISABLED
    @test.save
    redirect_to :back
  end

  def invite
    @test = Tst.find(params[:id])
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user

    if params[:invite].blank?
      flash[:notice] = "Please select people to invite and resubmit."
      redirect_to test_path(@test.id, @test.to_param)
    else
      if @token = current_user.facebook_token
        @graph = Koala::Facebook::GraphAPI.new(@token)
        params[:invite].each do |i|
          # WANT to send message (email via fb, or internal fb messages, doesn't matter), not post to walls. doesn't look like graph api supports that, though :-(
          # @graph.put_wall_post("has invited you to take a test:", {:name => @Tst.name, :link => test_url(@test)}, "me")
        end
      end
    end
  end

  def individual_results
    @test = Tst.load_active_by_id(params[:id])
    #redirect_to root_path and return unless user_signed_in? && @test.user == current_user
    @user = User.find(params[:user_id])
    @take = Take.find(params[:take])

  end

  def results
    @test = Tst.load_active_by_id(params[:id])
  end

  def questions
    @test = Tst.load_active_by_id(params[:id])
  end

  def comments
    @test = Tst.load_active_by_id(params[:id])
    @title = "Comments on #{@test.name} - Testeroni"
    @description = "Comments on '#{@test.name}' a test on Testeroni.com"

    @comment = Comment.new(:commentable_type => @test.class, :commentable_id => @test.id)
  end

  def update
    @test = Tst.find(params[:id])
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user

    if @Tst.update_attributes(params[:tst])
      redirect_to(@test, :notice => 'Test was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @test = Tst.find(params[:id])
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user

    @test.destroy
    redirect_to(:back, :notice => 'test DESTROYED!')
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def tst_params
      params.require(:tst).permit(:name, :description, :status, :contributors)
    end

end
