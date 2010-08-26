class StringToText < ActiveRecord::Migration
  def self.up
  	change_column :object_properties, :string_val, :text
  end

  def self.down
  	change_column :object_properties, :string_val, :string
  end
end
