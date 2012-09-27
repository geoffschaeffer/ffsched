class Matchup < ActiveRecord::Base
  attr_accessible :team1_id, :team2_id, :week
  belongs_to :league

  belongs_to :team1, class_name: "Team"
  belongs_to :team2, class_name: "Team"

  validates :team1_id, presence: true
  validates :team2_id, presence: true
  validates :league_id, presence: true

  validates_uniqueness_of :team1_id, { scope: :team2_id, message: "already has a matchup with Team2" }

  validates_uniqueness_of :team1_id, { scope: :week, message: "already has a matchup that week" }
  validates_uniqueness_of :team2_id, { scope: :week, message: "already has a matchup that week" }

  validate :team_cannot_play_self

  def get_display_name
    team1_obj = league.teams.find_by_id(team1_id)
    team2_obj = league.teams.find_by_id(team2_id)

    team1_name = "??"
    team2_name = "??"

    team1_name = team1_obj.name unless team1_obj == nil
    team2_name = team2_obj.name unless team2_obj == nil

    "#{team1_name} plays #{team2_name} on week #{week}"
  end

  def team_cannot_play_self
     if team1_id == team2_id then
       errors.add(:team1_id, "cannot play self")
     end
  end
end
