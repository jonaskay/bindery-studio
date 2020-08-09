class Pubsub::ErrorItem
  include ActiveModel::Validations

  attr_reader :name, :message

  validates :name, presence: true
  validates :message, presence: true

  def initialize(payload)
    @name = payload["name"]
    @message = payload["message"]
  end
end
