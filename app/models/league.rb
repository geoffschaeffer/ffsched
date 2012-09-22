class League < ActiveRecord::Base
  attr_accessible :name
  has_many :teams, dependent: :destroy

  validates :name,  presence: true, length: { maximum: 25 }, uniqueness: true
end
