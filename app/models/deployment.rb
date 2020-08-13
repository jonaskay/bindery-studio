class Deployment < ApplicationRecord
  scope :pending, -> { where(finished_at: nil, errored_at: nil) }

  belongs_to :project

  validates :instance, presence: true

  def pending?
    !finished? && !errored?
  end

  def finished?
    !finished_at.nil?
  end

  def errored?
    !errored_at.nil?
  end

  def handle_failure(message)
    return false unless pending?

    update!(errored_at: Time.current, error_message: message)
  end
end
