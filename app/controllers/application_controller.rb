# coding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # # from: https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-on-successful-sign-in
  # def after_sign_in_path_for(resource)
  #   if resource.is_a?(User)
  #     person_with_name_path(resource.id, resource.slugged_display_name)
  #   else
  #     super
  #   end
  # end
  
  # # adapted from: http://groups.google.com/group/plataformatec-devise/tree/browse_frm/month/2010-06?_done=/group/plataformatec-devise/browse_frm/month/2010-06%3F&
  # def stored_location_for(resource)
  #   if current_user
  #     # flash[:notice] = "You. Are. Signed. UP!"
  #     if params[:return_to]
  #       return params[:return_to]
  #     elsif cookies[:return_to]
  #       redir = cookies[:return_to]
  #       cookies.delete :return_to
  #       return redir
  #     end
  #   end
  #   super( resource ) 
  # end
  
  def after_sign_in_path_for(resource)
    if session[:return_to]
      redir = session[:return_to]
      session.delete(:return_to)
      return redir
    elsif params[:return_to]
      return params[:return_to]
    elsif cookies[:return_to]
      redir = cookies[:return_to]
      cookies.delete :return_to
      return redir
    end
    super
  end
  
  layout 'testeroni'
  
  before_filter :setup_user
  # before_filter :set_return_to, :except => ['sign_in']
  before_filter :promo
  
  def setup_user
    #for hidden signup form
    @user = User.new(:email_list => true) unless user_signed_in?
  end
  
  def set_return_to
    logger.debug "request.path: #{request.path}"
    session[:return_to] = request.path
  end
  
  def promo
    if promo = true
      msg = "THIS IS AN ALPHA VERSION of Testeroni. Data might not stick around."
      set_promo(msg, DateTime.new(y=2010, m=11, d=05))
      if (session[:promo][:dismissed_at].nil? || (session[:promo][:dismissed_at] < session[:promo][:created_at]))
        @promo = session[:promo]
      end
    else
      clear_promo
    end
  end
  
  # manages the session info for promo. don't call this directly. (see get_promo)
  def set_promo(msg, display_after)
    session[:promo] ||= {}
    session[:promo][:message] = msg
    session[:promo][:created_at] = display_after
    session[:promo][:dismissed_at] ||= nil
  end

  # clear the promo. don't call this directly. (see get_promo)
  def clear_promo
    session[:promo] = @promo = nil
  end
  
  # IF a user has taken tests but wasn't logged in, they'll be in the session. Check for those and persist them if they're there.
  def save_take_and_set_flash(user)
    if session[:take]
      Take.save_from_session_for_user(session, user)
      flash[:notice] = "Signed in successfully and saved the results of your last test."
    else
      flash[:notice] = "Signed in successfully."
    end
  end
  
  def url_escape(val)
    CGI.escape(val).gsub('+', '%20')
  end
  helper_method :url_escape
  
end
