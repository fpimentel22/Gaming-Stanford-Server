class ObjectProperties < ActiveRecord::Migration
  def self.up
  	rename_column :object_properties, :object_id, :obj_id
  end

  def self.down
  	rename_column :object_properties, :obj_id, :object_id
  end
end
