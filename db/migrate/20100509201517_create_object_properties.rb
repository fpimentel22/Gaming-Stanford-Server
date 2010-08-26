class CreateObjectProperties < ActiveRecord::Migration
  def self.up
    create_table :object_properties do |t|
      t.integer :object_id
      t.string :name
      t.integer :type
      t.integer :int_val
      t.float :float_val
      t.string :string_val
      t.binary :blob_val

      t.timestamps
    end
  end

  def self.down
    drop_table :object_properties
  end
end
