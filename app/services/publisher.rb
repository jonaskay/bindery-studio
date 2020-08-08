require 'googleauth'
require 'google/apis/compute_v1'

class Publisher
  class Error < StandardError; end

  attr_reader :project, :service, :google_cloud_project, :compute_engine_template, :compute_engine_zone

  def self.publish(project)
    self.new(project).insert_instance
  end

  def initialize(project)
    @project = project
    @service = Google::Apis::ComputeV1::ComputeService.new

    @google_cloud_project = ENV.fetch("GOOGLE_CLOUD_PROJECT")
    @compute_engine_template = ENV.fetch("COMPUTE_ENGINE_COMPOSITOR_TEMPLATE")
    @compute_engine_zone = ENV.fetch("COMPUTE_ENGINE_ZONE")

    authenticate_service
  end

  def insert_instance
    instance_name = "#{compute_engine_template}-#{project.id}"
    instance = Google::Apis::ComputeV1::Instance.new(name: instance_name)
    instance_template = "global/instanceTemplates/#{compute_engine_template}"

    service.insert_instance(
      google_cloud_project,
      compute_engine_zone,
      instance,
      source_instance_template: instance_template
    )
  end

  private

  def authenticate_service
    scopes = ["https://www.googleapis.com/auth/compute"]
    service.authorization = Google::Auth.get_application_default(scopes)
  end
end
