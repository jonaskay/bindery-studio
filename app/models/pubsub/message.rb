class Pubsub::Message
  include ActiveModel::Validations

  attr_reader :project, :error_data, :timestamp

  validates :project, presence: true
  validates :timestamp, presence: true,  datetime: true

  def self.from_encoded(data)
    decoded = JSON.parse(Base64.decode64(data))

    new(decoded)
  end

  def initialize(payload)
    @project = Pubsub::Project.new(payload["project"]) if payload["project"]
    @timestamp = payload["timestamp"]

    @error_data = (payload["errors"] || []).map do |error|
      Pubsub::ErrorItem.new(error)
    end
  end
end
