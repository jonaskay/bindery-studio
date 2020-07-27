class Publication < ApplicationRecord
  BASE_URL = "https://storage.googleapis.com/"

  scope :published, -> { where.not(published_at: nil) }

  belongs_to :user

  attr_readonly :name

  validates :title, presence: true
  validates :name, presence: true,
                   length: { maximum: 63 },
                   format: { with: /\A[a-z]([-a-z0-9]*[a-z0-9])?\z/ }
  validates :bucket, presence: true, if: -> { published?}

  def url
    return nil if bucket.nil?

    "#{BASE_URL}#{bucket}/#{name}/index.html"
  end

  def published?
    !published_at.nil?
  end

  def deployed?
    published? && !deployed_at.nil?
  end

  def publish
    return false unless published_at.nil?

    Publisher.publish(self)
    update!(published_at: Time.current,
            bucket: Rails.application.credentials.gcp.fetch(:storage_bucket))
  end
end
