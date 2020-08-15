class Deployment < ApplicationRecord
  self.implicit_order_column = "created_at"

  scope :pending, -> { where(finished_at: nil, failed_at: nil) }
  scope :finished, -> { where.not(finished_at: nil) }

  belongs_to :project

  validates :instance, presence: true

  def pending?
    !finished? && !failed?
  end

  def finished?
    !finished_at.nil?
  end

  def failed?
    !failed_at.nil?
  end

  def handle_success(timestamp = Time.current)
    update!(finished_at: timestamp)
  end

  def handle_failure(message, timestamp = Time.current)
    return false unless pending?

    update!(failed_at: timestamp, fail_message: message)
  end

  def handle_timeout(timestamp = Time.current)
    return false unless pending?

    ComputeEngine.delete_instance(instance)

    handle_failure("Timeout", timestamp)
  end
end
