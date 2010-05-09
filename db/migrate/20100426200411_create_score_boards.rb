class CreateScoreBoards < ActiveRecord::Migration
  def self.up
    create_table :score_boards do |t|
      t.integer :app_id
      t.integer :user_id
      t.integer :group_id
      t.integer :value
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :score_boards
  end
end
