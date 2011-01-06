# coding: utf-8

class RegistrationsController < Devise::RegistrationsController
  
  def create
    @user.password_confirmation = @user.password if @user && @user.password #hack
    super
    save_take_and_set_flash(@user)
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
  
end