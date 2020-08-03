class Message
  include ActiveModel::Validations

  SUCCESS = "success"

  attr_reader :publication_id, :status, :timestamp

  validates :publication_id, presence: true
  validates :status, inclusion: { in: [SUCCESS] }
  validates :timestamp, presence: true,  datetime: true

  def self.from_encoded(data)
    decoded = JSON.parse(Base64.decode64(data))

    Message.new(decoded)
  end

  def initialize(payload)
    @publication_id = payload["publicationId"]
    @status = payload["status"]
    @timestamp = payload["timestamp"]
  end
end
