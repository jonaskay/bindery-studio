FactoryBot.define do
  factory :deployment do
    project
    instance { "instance" }

    trait :pending do
      finished_at { nil }
      errored_at { nil }
    end

    trait :finished do
      finished_at { Time.current }
    end

    trait :errored do
      errored_at { Time.current }
      error_message { "error message" }
    end
  end
end
