require 'test_helper'

class AuthenticationTest < ActiveSupport::TestCase

  should "return Open ID as provider_name" do
    auth = Authentication.new(:provider => 'open_id')
    assert_equal "OpenID", auth.provider_name
  end
  
  should "return Twitter as provider_name" do
    auth = Authentication.new(:provider => 'twitter')
    assert_equal "Twitter", auth.provider_name
  end
  
  should "return Facebook as provider_name" do
    auth = Authentication.new(:provider => 'facebook')
    assert_equal "Facebook", auth.provider_name
  end

end
