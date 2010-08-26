class GroupsUser < ActiveRecord::Base
	validates_presence_of :user_id, :group_id
	validates_uniqueness_of :user_id, :scope => [:group_id], :message => "has already been added to this group."
	validate :group_must_exist
	validate :user_must_exist
	
	belongs_to :group
	belongs_to :user
	
	def group_must_exist
		errors.add_to_base("Specified group must already exist.") unless Group.exists?(group_id)
	end
	
	def user_must_exist
		errors.add_to_base("Specified user must already exist.") unless User.exists?(user_id)
	end
	
end
