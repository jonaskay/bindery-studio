FactoryBot.define do
  factory :message do
    publication { "publication" }
    status { "success" }
    timestamp { "1970-01-01T00:00:00.000Z" }

    initialize_with do
      payload = {
        "publication" => publication,
        "status" => status,
        "timestamp" => timestamp
      }

      new(payload)
    end
  end
end
