class AddIndexToTeamsLeagueId < ActiveRecord::Migration
  def change
    add_index :teams, :league_id
  end
end
