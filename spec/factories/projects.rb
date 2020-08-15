FactoryBot.define do
  factory :project do
    user
    sequence(:name) { |n| "project-#{n}" }
    title { "title" }

    trait :released do
      released_at { Time.current }
    end

    trait :deployed do
      after(:create) { |project| create(:deployment, :finished, project: project) }
    end

    trait :deployment_failed do
      after(:create) { |project| create(:deployment, :failed, project: project) }
    end

    trait :published do
      released
      deployed
    end

    trait :discarded do
      discarded_at { Time.current }
    end
  end
end
