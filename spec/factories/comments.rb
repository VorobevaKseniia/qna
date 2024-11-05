FactoryBot.define do
  factory :comment do
    body { 'comment' }

    association :user
    association :commentable

    trait :invalid do
      body { nil }
    end
  end
end
