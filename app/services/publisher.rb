require 'googleauth'
require 'google/apis/compute_v1'

class Publisher
  class Error < StandardError; end

  PUBLISH = :publish
  UNPUBLISH = :unpublish

  attr_reader :publication, :service, :template, :project, :zone

  def self.publish(publication)
    template = ENV["COMPUTE_ENGINE_PUBLISH_TEMPLATE"]

    self.new(publication, PUBLISH).insert_instance
  end

  def self.unpublish(publication)
    template = ENV["COMPUTE_ENGINE_UNPUBLISH_TEMPLATE"]

    self.new(publication, UNPUBLISH).insert_instance
  end

  def initialize(publication, template)
    @publication = publication
    @template = template
    @service = Google::Apis::ComputeV1::ComputeService.new

    @project = ENV["GOOGLE_CLOUD_PROJECT_ID"]
    @zone = ENV["COMPUTE_ENGINE_ZONE"]

    authenticate_service
  end

  def insert_instance
    instance_name = "#{template}-#{publication.id}"
    instance = Google::Apis::ComputeV1::Instance.new(name: instance_name)

    service.insert_instance(
      project,
      zone,
      instance,
      source_instance_template: source_instance_template
    )
  end

  private

  def source_instance_template
    instance_templates = {
      publish: ENV["COMPUTE_ENGINE_PUBLISH_TEMPLATE"],
      unpublish: ENV["COMPUTE_ENGINE_UNPUBLISH_TEMPLATE"]
    }

    "global/instanceTemplates/#{instance_templates[template]}"
  end

  def authenticate_service
    scopes = ["https://www.googleapis.com/auth/compute"]
    service.authorization = Google::Auth.get_application_default(scopes)
  end
end
