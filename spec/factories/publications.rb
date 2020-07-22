FactoryBot.define do
  factory :publication do
    user
    title { "title" }

    trait :published do
      published_at { Time.current }
    end
  end
end
