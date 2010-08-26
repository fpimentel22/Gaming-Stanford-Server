class ObjectProperty < ActiveRecord::Base
	validates_presence_of :name, :prop_type, :obj_id
	validates_uniqueness_of :name, :scope => [:obj_id]
	validate :must_fill_type

	belongs_to :obj
	
	def must_fill_type
		validated = case prop_type
			when 0 then !int_val.nil?
			when 1 then !float_val.nil?
			when 2 then !string_val.nil?
			when 3 then !blob_val.nil?
			else false
		end
		errors.add_to_base("Must fill value corresponding to specified type.") unless validated
	end
end
