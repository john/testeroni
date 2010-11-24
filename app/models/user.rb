# coding: utf-8

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         # , :token_authenticatable, :oauthable # for warden_oauth (twitter, facebook) support

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :username, :display_name, :email_list
  
  has_friendly_id :username, :use_slug => true
  
  has_many :authentications
  has_many :tests
  has_many :questions
  has_many :responses
  has_many :takes
  
  validates :username, :presence => true, :uniqueness => {:case_sensitive => false}, :format => {:with => /[A-Za-z0-9\-_]+/}
  
  def facebook_token
    @token = nil
    authentications.each do |a|
      @token = a.token if a.provider == 'facebook'
    end
    @token
  end
  
  # to allow people to log in with either email or username. see:
  # http://stackoverflow.com/questions/2997179/ror-devise-sign-in-with-username-or-email
  def self.find_for_database_authentication(conditions={})
    self.where("username = ?", conditions[:email]).limit(1).first ||
    self.where("email = ?", conditions[:email]).limit(1).first
  end
  
  def apply_omniauth(omniauth)
    if email.blank? && omniauth.has_key?('extra') && omniauth['extra'].has_key?('user_hash')
      self.email = omniauth['extra']['user_hash']['email']
    end
    
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'])
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

end