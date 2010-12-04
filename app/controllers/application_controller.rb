# coding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # from: https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-on-successful-sign-in
  # def after_sign_in_path_for(resource_or_scope)
  #   case resource_or_scope
  #   when :user, User 
  #      account_url
  #   else
  #      super
  #   end
  # end
  
  before_filter :setup_user
  
  def setup_user
    #for hidden signup form
    @user = User.new(:email_list => true) unless user_signed_in?
  end
  
  # adapted from: http://groups.google.com/group/plataformatec-devise/tree/browse_frm/month/2010-06?_done=/group/plataformatec-devise/browse_frm/month/2010-06%3F&
  def stored_location_for(resource)
    if current_user
      flash[:notice] = "You. Are. Signed. UP!"
      if params[:return_to]
        return params[:return_to]
      elsif cookies[:return_to]
        redir = cookies[:return_to]
        cookies.delete :return_to
        return redir
      end
    end
    super( resource ) 
  end
  
  def url_escape(val)
    CGI.escape(val).gsub('+', '%20')
  end
  helper_method :url_escape
  
end
