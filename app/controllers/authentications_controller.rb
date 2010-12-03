# coding: utf-8

class AuthenticationsController < ApplicationController
  
  def index
    @authentications = current_user.authentications if current_user
  end
  
  # I'm not really sure where the /auth paths come from--there's nothing in routes that match.
  # Maybe Rack? but in any case, need to set a session value before hitting it, so set up this
  # intermediate path. Might want to consider switching to the built-in support for omniauth in
  # recent versions of devise.
  def set_session_and_go
    logger.debug "GOT HERE!"
    # session[:redirect_to] = params[:redirect_to] if params[:redirect_to]
    redirect_to "/auth/#{params[:id]}"
  end
  
  def create
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    
    if authentication
      flash[:notice] = "Signed in successfully."
      
      # MAKE SURE this can direct to a passed-in value, so you can send them back to whence they came
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      # current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'])
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      
      # Get oauth info
      user = User.new
      user.apply_omniauth(omniauth)
      
      # if there's enough of it to save a valid user, do so
      if user.save
        flash[:notice] = "Signed in successfully."
        
        # see above...
        sign_in_and_redirect(:user, user)
        
      # if not, put the omniauth shit in the session and redirect to a page where they can add what's missing
      else
        
        # if omniauth['provider'] == 'twitter'
        #   session[:omniauth] = omniauth.except('extra')
        # else
          session[:omniauth] = omniauth
        # end
        
        redirect_to new_user_registration_url(:source => omniauth['provider'])
        #redirect_to last_step_url
      end
    end
  end
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
  
  def failure
  end
  
end