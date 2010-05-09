class User < ActiveRecord::Base
	has_and_belongs_to_many :apps
	has_and_belongs_to_many :groups
	has_many 				:friends
	has_many 				:objects
	has_many 				:score_boards
	
	# All the user related functions that will interact with the SDK. 
	# List from Gaming@Stanford Design Ideas:
	#
	
	
	#	registerUser
	#		create new user and set all fields
	#
	
	
	#	getProfile 
	#		return all the fields in the user tuple
	#
	
	
	#	setProfile
	#		edit the entire friends tuple
	#
	
	
	#	getFriends
	#		return an array of Friends(user)
	#
	
			
	#	getAppFriends
	#		return an array of Friends(user).user_id
	#			where user and friend both use App
	#
	
	
	#	getObjects
	#		return an array of game objects that belong to user
	#
	
	
	#	getMessages
	#		returen an array of messages directed at the user
	#	
	
end
