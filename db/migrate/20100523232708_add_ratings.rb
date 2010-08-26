class AddRatings < ActiveRecord::Migration

  def self.up
  	add_column :objs, :rating_count, :integer
  	add_column :objs, :rating_total, :integer
  end

  def self.down
  	remove_column :objs, :rating_count
  	remove_column :objs, :rating_total
  end
  
end
