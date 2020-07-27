FactoryBot.define do
  factory :publication do
    user
    title { "title" }
    sequence(:name) { |n| "publication-#{n}" }

    trait :published do
      published_at { Time.current }
      bucket { "bucket" }
    end
  end
end
