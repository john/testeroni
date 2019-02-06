class UserMailer < ApplicationMailer
  default from: "#{ENV['SITE_NAME']} <#{ENV['SITE_EMAIL']}>"
  track open: true, click: true

  # NOTE: @user should be set to support tracking by the `ahoy_email` gem

  def welcome
    @user = params[:user]

    mail(to: @user.email_with_name, subject: "Welcome to #{ENV['SITE_NAME']}")
  end
end
