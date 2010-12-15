# coding: utf-8

class AuthenticationsController < ApplicationController
  
  def index
    @authentications = current_user.authentications if current_user
  end
  
  def create    
    # render :text => request.env["omniauth.auth"].to_yaml
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    
    # they're signing in, and have previously authenticated
    if authentication
      
      if session[:take]
        Take.save_from_session_for_user(session, authentication.user)
        flash[:notice] = "Signed in successfully and saved the results of your last test."
      else
        flash[:notice] = "Signed in successfully."
      end
      sign_in_and_redirect(:user, authentication.user)
      
    # if they're already signed in, and they failed to authenticate, meaning they haven't previously set up fb or twitter
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'])

      if session[:take]
        Take.save_from_session_for_user(session, current_user)
        flash[:notice] = "Signed in successfully and saved the results of your last test."
      else
        flash[:notice] = "Signed in successfully."
      end
      
      redirect_to authentications_url
      
    # they don't have an existing account, but they just authenticated--so create an account
    else
      
      # Get oauth info
      user = User.new
      user.apply_omniauth(omniauth)
      
      # save user if you can. this never gets hit by this app, because we want to make people pick a username and add their email
      if user.save
        flash[:notice] = "Signed in successfully."
        
        # see above...
        sign_in_and_redirect(:user, user)
        
      # if they can't be saved (because validations fail, since there's no email or username yet), put the omniauth shit in the session and redirect to a page where they can add what's missing
      else
        
        # don't save all the twitter response, it's too big to fit in the cookie
        if omniauth['provider'] == 'twitter'
          session[:omniauth] = omniauth.except('extra')
        else
          session[:omniauth] = omniauth
        end
        
        # if params[:return_to]
        #   redirect_to new_user_registration_url(:source => omniauth['provider'])
        # else
        #   redirect_to new_user_registration_url(:source => omniauth['provider'], :return_to => params[:return_to])
        # end
        if cookies[:return_to]
          redir = cookies[:return_to]
          cookies.delete :return_to
          redirect_to new_user_registration_url(:source => omniauth['provider'], :return_to => redir)
        else
          redirect_to new_user_registration_url(:source => omniauth['provider'])
        end
        
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