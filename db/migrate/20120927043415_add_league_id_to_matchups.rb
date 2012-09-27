class AddLeagueIdToMatchups < ActiveRecord::Migration
  def change
    add_column :matchups, :league_id, :integer

    add_index :matchups, :league_id
  end
end
