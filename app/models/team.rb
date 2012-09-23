class Team < ActiveRecord::Base
  attr_accessible :name, :owner
  belongs_to :league

  validates :name,  presence: true, length: { maximum: 25 }, uniqueness: {scope: :league_id}
  validates :owner,  presence: true, length: { maximum: 50 }
  validates :league_id, presence: true
end
