class Object < ActiveRecord::Base
	belongs_to 	:app
	belongs_to 	:user
	belongs_to 	:group
	has_many	:object_properties
end
