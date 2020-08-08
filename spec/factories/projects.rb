FactoryBot.define do
  factory :project do
    user
    sequence(:name) { |n| "project-#{n}" }
    title { "title" }

    trait :published do
      published_at { Time.current }
    end

    trait :discarded do
      discarded_at { Time.current }
    end
  end
end
