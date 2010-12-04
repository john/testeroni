Rails.application.config.middleware.use OmniAuth::Builder do
  # twitter is declared in devise, apparently?
  provider :twitter, 'adDpYLfK76cWFG5kPuKiUQ', 'ENy2ZSYsQLfywOtnYOmu1L8b8ANZPPmGrk0zXibRE'
  provider :facebook, '164974673542646', 'efa7a0626a2203b5d4ca475d7a10c322', {:scope => 'email'}
  
  # http://developers.facebook.com/docs/authentication/permissions
  # other possibly useful facebook permissions, for the scope value above:
  #,publish_stream,offline_access
  
  # provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end

# twitter dev page:
# http://dev.twitter.com/apps/522225

# monkey patch so you can pass a return_to url to the callback:
# https://gist.github.com/725752
# i think the same thing is going on on this fork:
# https://github.com/davidbalbert/omniauth/commit/09fa95c0f5f13e314d46c28b0b16a5f8dfccf7ec
# class OmniauthCallbacksController < Devise::OmniauthCallbacksController
#   def twitter
#     ...
# 
#     sign_in @user
#     redirect_to params[:return_to]
#   end
# end
# 
# module OmniAuth
#   module Strategy
#     def callback_url
#       full_host + "#{OmniAuth.config.path_prefix}/#{name}/callback?return_to=#{request.params['return_to'] || request.referer}"
#     end
#   end
# end