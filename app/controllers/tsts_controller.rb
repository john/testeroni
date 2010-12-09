# coding: utf-8

class TstsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show]
  
  # GET /tests
  # GET /tests.xml
  def index
    @tests = Tst.all
    @title = "Make surveys and quizzes from YouTube videos - Test"
    @description = "Test lets you make surveys and quizzes from YouTube videos."

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tests }
    end
  end

  # GET /tests/1
  # GET /tests/1.xml
  def show
    @test = Tst.load_active_by_id(params[:id])
    
    @owner = true if user_signed_in? && @test.owned_by?(current_user)
    @title = "#{@test.name} - Test"
    @description = "'#{@test.name}' on Tst."
    
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
    
    @comment = Comment.new
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @test }
    end
  end

  # GET /tests/new
  # GET /tests/new.xml
  def new
    redirect_to root_path and return unless user_signed_in?
    
    @test = Tst.new(:contributors => Tst::ANYONE)
    @title = "Create a new quiz or survey - Test"
    @description = "Create a new quiz or survey on Tst."

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @test }
    end
  end

  # GET /tests/1/edit
  def edit
    @test = Tst.find(params[:id])
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user
  end

  # POST /tests
  # POST /tests.xml
  def create
    @test = Tst.new(params[:tst])
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

    respond_to do |format|
      if @test.save
        format.html { redirect_to( new_question_path(:test_id => @test.id), :notice => 'Test was successfully created.') }
        format.xml  { render :xml => @test, :status => :created, :location => @test }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @Tst.errors, :status => :unprocessable_entity }
      end
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
          logger.debug "INVITE:----------> #{i.inspect}"
        end
      end
    end
  end
  
  def individual_results
    @test = Tst.load_active_by_id(params[:id])
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user
    
    @user = User.find(params[:username])
    @take = Take.find(params[:take])
    
  end
  
  def results
    @test = Tst.find_by_sql(['SELECT * FROM tsts WHERE id=? LIMIT 1', params[:id].to_i])[0]
  end
  
  def questions
    @test = Tst.find_by_sql(['SELECT * FROM tsts WHERE id=? LIMIT 1', params[:id].to_i])[0]
  end

  # PUT /tests/1
  # PUT /tests/1.xml
  def update
    @test = Tst.find(params[:id])
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user
    
    respond_to do |format|
      if @Tst.update_attributes(params[:tst])
        format.html { redirect_to(@test, :notice => 'Test was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @test.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tests/1
  # DELETE /tests/1.xml
  def destroy
    @test = Tst.find(params[:id])
    redirect_to root_path and return unless user_signed_in? && @test.user == current_user
    
    @test.destroy

    respond_to do |format|
      format.html do
        #redirect_to(tests_url)
        redirect_to(:back, :notice => 'test DESTROYED!')
      end
      format.xml  { head :ok }
    end
  end
end
