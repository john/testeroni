class RegistrationsController < Devise::RegistrationsController
  
  def create
    @user.password_confirmation = @user.password if @user && @user.password #hack
    super
    session[:omniauth] = nil unless @user.new_record?
  end
  
  private
  
  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end
  
  def last_step
  end
  
  
  
end