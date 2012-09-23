class League < ActiveRecord::Base
  attr_accessible :name
  has_many :teams, dependent: :destroy

  validates :name,  presence: true, length: { maximum: 25 }, uniqueness: true

  def has_room?
    return teams.length < 14
  end

  private

    def num_teams_in_bounds
      return if teams.blank?
      errors.add("Teams in a league limited to #{@max_teams}") if teams.length > 14
    end
end
