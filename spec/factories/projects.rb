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

    trait :deployment_timed_out do
      released_at { 1.hour.ago }
    end

    trait :deployment_errored do
      after(:create) { |project| create(:project_message, :error, project: project) }
    end

    trait :deployment_failed do
      deployment_timed_out
      deployment_errored
    end
  end
end
