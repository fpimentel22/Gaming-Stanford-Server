class App < ActiveRecord::Base
	belongs_to 				:developer
	has_and_belongs_to_many :users
	has_many 				:groups
	has_many 				:objects
	has_many 				:score_boards
end
