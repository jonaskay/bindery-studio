class Pubsub::Project
  include ActiveModel::Validations

  attr_reader :id

  validates :id, presence: true

  def initialize(payload)
    @id = payload["id"]
  end
end
