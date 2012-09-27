class CreateMatchups < ActiveRecord::Migration
  def change
    create_table :matchups do |t|
      t.integer :team1_id
      t.integer :team2_id
      t.integer :week

      t.timestamps
    end

    add_index :matchups, :team1_id
    add_index :matchups, :team2_id
    add_index :matchups, [:team1_id, :team2_id], unique: true
  end
end
