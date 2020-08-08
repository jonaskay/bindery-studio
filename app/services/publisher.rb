require 'googleauth'
require 'google/apis/compute_v1'

class Publisher
  class Error < StandardError; end

  PUBLISH = :publish
  UNPUBLISH = :unpublish

  attr_reader :project, :service, :google_cloud_project, :compute_engine_template, :compute_engine_zone

  def self.publish(project)
    template = ENV["COMPUTE_ENGINE_PUBLISH_TEMPLATE"]

    self.new(project, PUBLISH).insert_instance
  end

  def initialize(project, compute_engine_template)
    @project = project
    @service = Google::Apis::ComputeV1::ComputeService.new

    @google_cloud_project = ENV.fetch("GOOGLE_CLOUD_PROJECT")
    @compute_engine_template = compute_engine_template
    @compute_engine_zone = ENV.fetch("COMPUTE_ENGINE_ZONE")

    authenticate_service
  end

  def insert_instance
    instance_name = "#{compute_engine_template}-#{project.id}"
    instance = Google::Apis::ComputeV1::Instance.new(name: instance_name)

    service.insert_instance(
      google_cloud_project,
      compute_engine_zone,
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

    "global/instanceTemplates/#{instance_templates[compute_engine_template]}"
  end

  def authenticate_service
    scopes = ["https://www.googleapis.com/auth/compute"]
    service.authorization = Google::Auth.get_application_default(scopes)
  end
end
