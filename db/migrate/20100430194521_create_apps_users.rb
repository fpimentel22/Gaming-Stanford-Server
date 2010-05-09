class CreateAppsUsers < ActiveRecord::Migration
  def self.up
    create_table :apps_users do |t|
      t.integer :app_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :apps_users
  end
end
