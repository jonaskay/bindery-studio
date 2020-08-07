class Pubsub::Project
  include ActiveModel::Validations

  attr_reader :id, :name

  validates :id, presence: true
  validates :name, presence: true

  def initialize(payload)
    @id = payload["id"]
    @name = payload["name"]
  end
end
