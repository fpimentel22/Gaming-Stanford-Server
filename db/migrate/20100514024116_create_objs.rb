class CreateObjs < ActiveRecord::Migration
  def self.up
    create_table :objs do |t|
      t.integer :app_id
      t.integer :user_id
      t.integer :group_id
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :objs
  end
end
