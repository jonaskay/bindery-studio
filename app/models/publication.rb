class Publication < ApplicationRecord
  include Discard::Model

  self.implicit_order_column = "created_at"

  MIN_NAME_LENGTH = 1
  MAX_NAME_LENGTH = 63

  scope :published, -> { kept.where.not(published_at: nil) }

  belongs_to :user

  attr_readonly :name

  validates :title, presence: true
  validates :name, presence: true,
                   length: { maximum: MAX_NAME_LENGTH },
                   format: { with: /\A[a-z0-9]([-a-z0-9]*[a-z0-9])?\z/ }

  after_discard :unpublish, if: -> { published? }

  def to_param
    name
  end

  def url
    "#{ENV["BASE_URL"]}#{name}/index.html"
  end

  def published?
    !published_at.nil?
  end

  def unpublished?
    !published?
  end

  def deployed?
    published? && !deployed_at.nil?
  end

  def publish
    return false if published? || discarded?

    Publisher.publish(self)
    update!(published_at: Time.current)
  end

  def unpublish
    Cleaner.clean(self)
    update!(published_at: nil)
  end

  def confirm_deployment(timestamp)
    update_attribute(:deployed_at, timestamp)
  end

  def confirm_cleanup
    return false if undiscarded?

    destroy
  end
end
