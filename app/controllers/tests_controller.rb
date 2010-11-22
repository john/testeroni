class TestsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show]
  
  # GET /tests
  # GET /tests.xml
  def index
    @tests = Test.all
    @title = "Make surveys and quizzes from YouTube videos - Testeroni"
    @description = "Testeroni lets you make surveys and quizzes from YouTube videos."

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tests }
    end
  end

  # GET /tests/1
  # GET /tests/1.xml
  def show
    
    # should require signin
    
    @test = Test.find(params[:id])
    @owner = true if user_signed_in? && @test.owned_by?(current_user)
    @title = "#{@test.name} - Testeroni"
    @description = "'#{@test.name}' on Testeroni."
    @question_number = 1
    
    # # this is done both here and in QuestionsController#show. How to dry it up?
    # 
    # # embarrassing hack. 'a' is only present when we're adding questions, which means we're
    # # not actually taking the test, and shouldn't be creating takings. come up with a better
    # # mechanism.
    # if @test.published? && !params[:a]
    #   @taking = Taking.new
    #   @taking.test = @test
    #   @taking.user = current_user
    #   @taking.started_at = Time.now
    #   @taking.save
    # end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @test }
    end
  end

  # GET /tests/new
  # GET /tests/new.xml
  def new
    @test = Test.new
    @title = "Create a new quiz or survey - Testeroni"
    @description = "Create a new quiz or survey on Testeroni."

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @test }
    end
  end

  # GET /tests/1/edit
  def edit
    @test = Test.find(params[:id])
  end

  # POST /tests
  # POST /tests.xml
  def create
    @test = Test.new(params[:test])
    @test.user = current_user
    
    if @test.video_url
      @video = Video.new
      @video.url = @test.video_url
      @video.test = @test
      # enter video name? get it from YouTube?
      
      @video.provider_id = @video.get_provider_id_from_url
      @video.save
    end

    respond_to do |format|
      if @test.save
        # format.html { redirect_to(@test, :notice => 'Test was successfully created.') }
        format.html { redirect_to( new_question_path(:test_id => @test.id), :notice => 'Test was successfully created.') }
        format.xml  { render :xml => @test, :status => :created, :location => @test }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @test.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def publish
    @test = Test.find(params[:id])
    @test.published_at = Time.now
    @test.save
  end
  
  def individual_results
    @test = Test.find(params[:id])
    @user = User.find(params[:username])
    
    @completions = CompletedTest.where("user_id = ?", @user.id)
  end
  
  def aggregated_results
    @test = Test.find(params[:id])
  end

  # PUT /tests/1
  # PUT /tests/1.xml
  def update
    @test = Test.find(params[:id])

    respond_to do |format|
      if @test.update_attributes(params[:test])
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
    @test = Test.find(params[:id])
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
