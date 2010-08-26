class AddGroupOwnerId < ActiveRecord::Migration
  def self.up
    add_column :groups, :owner_id, :integer
  end

  def self.down
    remove_column :groups, :owner_id
  end
end
