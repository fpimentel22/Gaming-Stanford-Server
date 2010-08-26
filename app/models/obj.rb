class Obj < ActiveRecord::Base
	validates_presence_of :app_id, :obj_type
	validate :must_belong_to_entity

	belongs_to 	:app
	belongs_to 	:user
	belongs_to 	:group
	
	has_many	:object_properties, :dependent => :destroy
	
	def must_belong_to_entity
		errors.add_to_base("Object must belong to user or group.") unless (!user_id.nil? || !group_id.nil?)
	end
	
end
