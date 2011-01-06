# coding: utf-8

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :token_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  
  attr_accessible :email, :password, :password_confirmation, :remember_me, :auth_id, :first_name, :last_name, :display_name, :timezone, :email_list
  
  validates :display_name, :presence => true
  # validates :email, :presence => true, :uniqueness => {:case_sensitive => false}, :format => {:with => /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/}
  
  has_many :tsts
  has_many :questions
  has_many :responses
  has_many :takes
  has_many :activities
  
  FACEBOOK = 0
  TWITTER = 1
  TSTRNI = 2
  
  def slugged_display_name
    display_name.gsub(' ', '-').delete("?/#")
  end
  
  # from: https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    
    if user = User.find_by_email(data["email"])
      user
    else # Create an user with a stub password. 
      User.create!( :email => data['email'],
                    :auth_service => User::FACEBOOK,
                    :auth_id => data['id'],
                    :first_name => data['first_name'],
                    :last_name => data['last_name'],
                    :display_name => data['name'],
                    :utc_offset => data['timezone'].to_i * 60 * 60,
                    :lang => data['locale'],
                    :password => Devise.friendly_token[0,20]) 
    end
  end
  
  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil, email)
    data = access_token['extra']['user_hash']
    
    # available:
    # "name"=>"John McGrath" (use for :display_name)
    # "utc_offset"=>-18000 (use for :timezone)
    # "screen_name"=>"Wordie" (use for :auth_id)
    
    if user = User.find_by_email(email)
      user
    else # Create an user with a stub password. 
      User.create!( :email => email,
                    :auth_service => User::TWITTER,
                    :auth_id => data['screen_name'],
                    :display_name => data['name'],
                    :utc_offset => data['timezone'].to_i,
                    :lang => data['lang'],
                    :password => Devise.friendly_token[0,20])
    end
  end
  
  # to allow people to log in with either email or username. see:
  # http://stackoverflow.com/questions/2997179/ror-devise-sign-in-with-username-or-email
  def self.find_for_database_authentication(conditions={})
    self.where("username = ?", conditions[:email]).limit(1).first ||
    self.where("email = ?", conditions[:email]).limit(1).first
  end
  
  # from: https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.email = data["email"]
      end
    end
  end
  
end
