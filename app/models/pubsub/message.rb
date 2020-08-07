class Pubsub::Message
  include ActiveModel::Validations

  SUCCESS = "success"

  attr_reader :project, :status, :timestamp

  validates :project, presence: true
  validates :status, inclusion: { in: [SUCCESS] }
  validates :timestamp, presence: true,  datetime: true

  def self.from_encoded(data)
    decoded = JSON.parse(Base64.decode64(data))

    new(decoded)
  end

  def initialize(payload)
    @project = Pubsub::Project.new(payload["project"]) if payload["project"]
    @status = payload["status"]
    @timestamp = payload["timestamp"]
  end
end
