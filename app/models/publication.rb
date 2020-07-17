class Publication < ApplicationRecord
  has_one :site, dependent: :destroy

  belongs_to :user

  delegate :url, to: :site

  validates :title, presence: true

  def publish
    return false unless published_at.nil?

    site_name = Publisher.publish
    create_site!(name: site_name, bucket: Rails.application.credentials.gcp.fetch(:storage_bucket))
    update_attribute(:published_at, Time.current)
  end
end
