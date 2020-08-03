FactoryBot.define do
  factory :publication do
    user
    title { "title" }
    sequence(:name) { |n| "publication-#{n}" }

    trait :published do
      published_at { Time.current }
    end

    trait :discarded do
      discarded_at { Time.current }
    end
  end
end
