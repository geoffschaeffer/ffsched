FactoryGirl.define do
  factory :league do
    sequence(:name)  { |n| "League #{n}" }
  end

  factory :team do
    sequence(:name)  { |n| "Team #{n}" }
    sequence(:owner)  { |n| "Owner #{n}" }
  end
end