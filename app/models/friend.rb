class Friend < ActiveRecord::Base
	validates_uniqueness_of :friend_id, :scope => [:user_id]
	
	belongs_to :user
end
