class Team < ActiveRecord::Base
  attr_accessible :name, :owner
  belongs_to :league

  validates :name,  presence: true, length: { maximum: 50 }, uniqueness: true
  validates :owner,  presence: true, length: { maximum: 50 }
  validates :league_id, presence: true
end
