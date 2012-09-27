class Team < ActiveRecord::Base
  attr_accessible :name, :owner
  belongs_to :league

  has_many :matchups, foreign_key: "team1_id", dependent: :destroy
  has_many :home_matchups, through: :matchups, source: :team2
  has_many :reverse_matchups, foreign_key: "team2_id",
           class_name:  "Matchup",
           dependent:   :destroy
  has_many :away_matchups, through: :reverse_matchups, source: :team1

  validates :name,  presence: true, length: { maximum: 25 }, uniqueness: {scope: :league_id}
  validates :owner,  presence: true, length: { maximum: 50 }
  validates :league_id, presence: true
end
