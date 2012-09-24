class League < ActiveRecord::Base
  attr_accessible :name
  has_many :teams, dependent: :destroy

  validates :name,  presence: true, length: { maximum: 25 }, uniqueness: true

  def get_max_teams
    return 14
  end

  def has_room?
    return teams.length < get_max_teams
  end

  def team_index_even?(team)
    (teams.index(team) % 2) == 0
  end

  def team_index_last(team)
    teams.index(team) == (teams.length - 1)
  end

  private

    def num_teams_in_bounds
      return if teams.blank?
      errors.add("Teams in a league limited to #{get_max_teams}") if teams.length > get_max_teams
    end
end
