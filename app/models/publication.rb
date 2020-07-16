class Publication < ApplicationRecord
  belongs_to :user

  validates :title, presence: true

  def publish
    return false unless published_at.nil?

    Publisher.publish
    update_attribute(:published_at, Time.current)
  end
end
