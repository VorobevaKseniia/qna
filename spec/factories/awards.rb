FactoryBot.define do
  factory :award do
    title { 'Best answer' }

    association :question
    association :user

    trait :invalid do
      title { nil }
    end
  end
end
