require 'googleauth'
require 'google/apis/compute_v1'
require 'google/apis/storage_v1'

class Publisher
  class Error < StandardError; end

  SCOPES = ["https://www.googleapis.com/auth/compute"]

  def initialize(options = {})
    @project = options.fetch(:project, Rails.application.credentials.gcp.fetch(:project))
    @zone = options.fetch(:zone, Rails.application.credentials.gcp.fetch(:zone))
  end

  def self.publish(publication)
    self.new.publish(publication)
  end


  def self.unpublish(publication)
    StorageCleanupJob.perform_later(publication.bucket, publication.name)
  end

  def self.read(data)
    payload = JSON.parse(Base64.decode64(data))
    message = Message.new(payload)

    unless message.valid?
      error = message.errors.full_messages.first
      raise Publisher::Error.new("Invalid message: #{error}")
    end

    publication = Publication.find_by(name: message.publication)
    if publication.nil?
      raise Publisher::Error.new("Couldn't find publication")
    end

    publication.update_attribute(:deployed_at, message.timestamp)
  end

  def publish(publication)
    service = Google::Apis::ComputeV1::ComputeService.new
    service.authorization = Google::Auth.get_application_default(["https://www.googleapis.com/auth/compute"])

    instance = Google::Apis::ComputeV1::Instance.new(name: publication.name)

    response = service.insert_instance(
      @project,
      @zone,
      instance,
      source_instance_template: source_instance_template
    )
  end

  private

  def source_instance_template
    instance_template = Rails.application.credentials.gcp.fetch(:instance_template)

    "global/instanceTemplates/#{instance_template}"
  end
end
