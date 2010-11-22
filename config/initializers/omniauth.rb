Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'adDpYLfK76cWFG5kPuKiUQ', 'ENy2ZSYsQLfywOtnYOmu1L8b8ANZPPmGrk0zXibRE'
  provider :facebook, '164974673542646', 'efa7a0626a2203b5d4ca475d7a10c322'
  # provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end

# twitter dev page:
# http://dev.twitter.com/apps/522225