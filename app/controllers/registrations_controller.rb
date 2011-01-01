# coding: utf-8

class RegistrationsController < Devise::RegistrationsController
  
  def create
    logger.debug ":::::::::::::::::::::> IN RegistrationsController#create"
    @user.password_confirmation = @user.password if @user && @user.password #hack
    
    # the call below ALWAYS tries to redirect to root_path. Even when there isn't one, or 
    super
    
    save_take_and_set_flash(@user)
    # session[:omniauth] = nil unless @user.new_record?
    # redirect_to (stored_location_for(:user) || root_path)
  end
  
  def new
    # if session[:omniauth]
    #   if session[:omniauth]['provider'] == 'facebook'
    #     @token = session[:omniauth]['credentials']['token']
    #     @graph = Koala::Facebook::GraphAPI.new("#{@token}")
    #     @picture = @graph.get_picture("me")
    #     @username = session[:omniauth]['user_info']['name']
    #   elsif session[:omniauth]['provider'] == 'twitter'
    #     @picture = session[:omniauth]['user_info']['image']
    #     @username = session[:omniauth]['user_info']['nickname']
    #   end
    # end
    logger.debug ":::::::::::::::::::::>IN RegistrationsController#NEW"
    super
    
    if session[:take]
      flash[:notice] = "Successfully created an account and saved the results of your last test."
      Take.save_from_session_for_user(session, @user)
    end
    
  end
  
  private
  
  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end
  
  protected
  def after_sign_up_path_for(resource)
    logger.debug "----------------> GOT TO after_sign_up_path_for in registrations_controller"
    'http://www.cnn.com'
  end
  
end