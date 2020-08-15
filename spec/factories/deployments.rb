FactoryBot.define do
  factory :deployment do
    project
    instance { "instance" }

    trait :pending do
      finished_at { nil }
      failed_at { nil }
    end

    trait :finished do
      finished_at { Time.current }
    end

    trait :failed do
      failed_at { Time.current }
      fail_message { "fail" }
    end
  end
end
