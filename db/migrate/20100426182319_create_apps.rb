class CreateApps < ActiveRecord::Migration
  def self.up
    create_table :apps do |t|
      t.string :name
      t.integer :api_key
      t.integer :developer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :apps
  end
end
