class User < ActiveRecord::Base
	validates_presence_of :first_name, :last_name, :email
	validates_uniqueness_of :email
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

	has_and_belongs_to_many :apps
	has_and_belongs_to_many :groups
	has_many 				:friends
	has_many 				:objs
	has_many 				:score_boards
	has_many				:groups_users
	
end
