class Activity < ActiveRecord::Base
  
  # verbs
  FAVORITE = 0
  FOLLOW = 1
  SHARE = 2
  TAG = 3
  COMMENT = 4
  CREATE = 5
  UPDATE = 6
  TAKE = 7
  
  # objects
  USER = 0
  TST = 1
  
  belongs_to :user
  
end
