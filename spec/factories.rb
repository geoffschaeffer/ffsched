FactoryGirl.define do
  factory :league do
    sequence(:name)  { |n| "League #{n}" }
  end

  factory :team do
    sequence(:name)  { |n| "Team #{n}" }
    sequence(:owner)  { |n| "Owner #{n}" }
  end

  factory :matchup do
    week 1
  end
end