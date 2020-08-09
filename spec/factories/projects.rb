FactoryBot.define do
  factory :project do
    user
    sequence(:name) { |n| "project-#{n}" }
    title { "title" }

    trait :released do
      released_at { Time.current }
    end

    trait :deployed do
      deployed_at { Time.current }
    end

    trait :published do
      released
      deployed
    end

    trait :discarded do
      discarded_at { Time.current }
    end

    trait :errored do
      after(:create) { |project| create(:project_message, :error, project: project) }
    end
  end
end
