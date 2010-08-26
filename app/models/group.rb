class Group < ActiveRecord::Base
	validates_presence_of	:app_id, :name
	validates_uniqueness_of :name, :scope => [:app_id]

	belongs_to 				:app
	has_and_belongs_to_many :users
	has_many 				:objs, :dependent => :destroy
	has_many 				:score_boards, :dependent => :destroy
	has_many				:groups_users, :dependent => :destroy
	
	#named_scope				:user, :include => :groups_user, lambda { |user_id| { :conditions => { :groups_users => ['groups_users.user_id' => user_id] } } }
	#named_scope				:name, lambda { |name| { :conditions => ['name' => name] } }
  
end
