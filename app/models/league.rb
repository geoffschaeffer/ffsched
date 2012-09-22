class League < ActiveRecord::Base
  attr_accessible :name

  validates :name,  presence: true, length: { maximum: 25 }, uniqueness: true
end
