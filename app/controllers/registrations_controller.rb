# coding: utf-8

class RegistrationsController < Devise::RegistrationsController
  
  def create
    @user.password_confirmation = @user.password if @user && @user.password #hack
    super
    session[:omniauth] = nil unless @user.new_record?
  end
  
  def new
    if session[:omniauth] && session[:omniauth]['provider'] == 'facebook'
      @token = session[:omniauth]['credentials']['token']
      @graph = Koala::Facebook::GraphAPI.new("#{@token}")
      @fbpicture = @graph.get_picture("me")
      @username = session[:omniauth]['user_info']['name']
    end
    
    super
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