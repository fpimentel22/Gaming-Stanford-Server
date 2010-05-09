class Group < ActiveRecord::Base
	belongs_to 				:app
	has_and_belongs_to_many :users
	has_many 				:objects
	has_many 				:scoreboards
end
