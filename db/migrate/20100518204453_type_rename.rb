class TypeRename < ActiveRecord::Migration
  def self.up
  	rename_column :objs, :type, :obj_type
  	rename_column :object_properties, :type, :prop_type
  	rename_column :score_boards, :type, :sb_type
  end

  def self.down
  	rename_column :objs, :obj_type, :type
  	rename_column :object_properties, :prop_type, :type
  	rename_column :score_boards, :sb_type, :type
  end
end
