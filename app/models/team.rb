class Team < ActiveRecord::Base
  attr_accessible :name, :owner

  validates :name,  presence: true, length: { maximum: 50 }, uniqueness: true
  validates :owner,  presence: true, length: { maximum: 50 }
end
