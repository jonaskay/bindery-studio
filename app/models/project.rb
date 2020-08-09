class Project < ApplicationRecord
  include Discard::Model

  self.implicit_order_column = "created_at"

  MIN_NAME_LENGTH = 1
  MAX_NAME_LENGTH = 63

  scope :revealed, -> { kept.where.not(released_at: nil) }

  has_many :messages, dependent: :destroy

  belongs_to :user

  attr_readonly :name

  validates :title, presence: true
  validates :name, presence: true,
                   length: { maximum: MAX_NAME_LENGTH },
                   format: { with: /\A[a-z0-9]([-a-z0-9]*[a-z0-9])?\z/ },
                   uniqueness: { case_sensitive: false }

  after_discard :unpublish, if: -> { published? }

  def to_param
    name
  end

  def url
    "#{ENV.fetch("DEPLOYED_BASE_URL")}/#{name}/index.html"
  end

  def hidden?
    released_at.nil?
  end

  def released?
    !released_at.nil?
  end

  def deployed?
    !deployed_at.nil?
  end

  def published?
    released? && deployed?
  end

  def errored?
    released? && messages.error.any? && released_at < messages.last.created_at
  end

  def status
    attribute = if discarded?
                  :deleting
                elsif hidden?
                  :unpublished
                elsif released?
                  if errored?
                    :error
                  elsif deployed?
                    :published
                  else
                    :publishing
                  end
                else
                  raise Project::Error.new("Unknown state")
                end

    I18n.t("activerecord.attributes.#{self.class.name.underscore}.statuses.#{attribute}")
  end

  def publish
    return false if discarded? || released? && !errored?

    Publisher.publish(self)
    update!(released_at: Time.current)
  end

  def unpublish
    Cleaner.clean(self)
    update!(released_at: nil)
  end

  def confirm_deployment(timestamp)
    update_attribute(:deployed_at, timestamp)
  end

  def confirm_cleanup
    return false if undiscarded?

    destroy
  end
end
