FactoryBot.define do
  factory :vote do
    value { 1 }

    association :user
    association :votable
  end
end
