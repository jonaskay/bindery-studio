class Message
  include ActiveModel::Validations

  SUCCESS = "success"

  attr_reader :publication, :status, :timestamp

  validates :publication, presence: true
  validates :status, inclusion: { in: [SUCCESS] }
  validates :timestamp, presence: true,  datetime: true

  def initialize(payload)
    @publication = payload["publication"]
    @status = payload["status"]
    @timestamp = payload["timestamp"]
  end
end
