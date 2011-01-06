class Activity < ActiveRecord::Base
  
  FAVORITE = 0
  FOLLOW = 1
  SHARE = 2
  TAG = 3
  UPDATE = 4
  CREATE = 5
  TAKE = 6
  
  belongs_to :user
  
end
