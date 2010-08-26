class AddFbPhoto < ActiveRecord::Migration
  def self.up
  	add_column :users, :fb_photo, :string
  end

  def self.down
  	remove_column :users, :fb_photo
  end
end
