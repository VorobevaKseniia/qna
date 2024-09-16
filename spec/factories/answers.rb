FactoryBot.define do
  factory :answer do
    body { "MyText" }

    association :question
    association :user

    trait :invalid do
      body { nil }
    end
  end
end
