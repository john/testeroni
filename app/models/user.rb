class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :registerable
  #, :token_authenticatable, :validatable, :omniauthable

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, :presence => true
  # validates :email, :presence => true, :uniqueness => {:case_sensitive => false}, :format => {:with => /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/}

  has_many :tsts
  has_many :questions
  has_many :responses
  has_many :takes
  has_many :activities

  # FACEBOOK = 0
  # TWITTER = 1
  # TSTRNI = 2

  def slugged_name
    name.gsub(' ', '-').delete("?/#")
  end

  # # from: https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
  # def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
  #   data = access_token['extra']['user_hash']
  #
  #   if user = User.find_by_email(data["email"])
  #     user
  #   else # Create an user with a stub password.
  #     User.create!( :email => data['email'],
  #                   :auth_service => User::FACEBOOK,
  #                   :auth_id => data['id'],
  #                   :name => data['name'],
  #                   :utc_offset => data['timezone'].to_i * 60 * 60,
  #                   :lang => data['locale'],
  #                   :password => Devise.friendly_token[0,20])
  #   end
  # end
  #
  # def self.find_for_twitter_oauth(access_token, signed_in_resource=nil, email)
  #   data = access_token['extra']['user_hash']
  #
  #   # available:
  #   # "name"=>"John McGrath" (use for :display_name)
  #   # "utc_offset"=>-18000 (use for :timezone)
  #   # "screen_name"=>"Wordie" (use for :auth_id)
  #
  #   if user = User.find_by_email(email)
  #     user
  #   else # Create an user with a stub password.
  #     User.create!( :email => email,
  #                   :auth_service => User::TWITTER,
  #                   :auth_id => data['screen_name'],
  #                   :name => data['name'],
  #                   :utc_offset => data['timezone'].to_i,
  #                   :lang => data['lang'],
  #                   :password => Devise.friendly_token[0,20])
  #   end
  # end

  # to allow people to log in with either email or username. see:
  # http://stackoverflow.com/questions/2997179/ror-devise-sign-in-with-username-or-email
  def self.find_for_database_authentication(conditions={})
    # self.where("username = ?", conditions[:email]).limit(1).first ||
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

  def unique_tests_taken
    tests_taken = []
    self.takes.pluck(:tst_id).uniq.each do |test_id|
      tests_taken << Tst.find(test_id)
    end
    tests_taken
  end

  def follow(thing)
    if follow = Follow.create(:user_id => id, :follow_type => thing.class.to_s, :follow_id => thing.id)
      true
    else
      false
    end
  end

  def is_following?(thing)
    followee = Object.const_get(thing.class.to_s).find(thing.id)
    if the_follow = Follow.where(["follow_type = ? AND follow_id = ?", followee.class.to_s, followee.id])
      if the_follow.size > 0
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def get_follow_activity
    # get people you follow
    @user_follows = Follow.where(["user_id=? AND object_type=", id])
    # get their activities

    # get tests you follow
    # get activity of those tests
    user_activities = Activity.where([""])
  end

end
