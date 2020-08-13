require "googleauth"
require "google/apis/compute_v1"

class Publisher
  class Error < StandardError; end

  attr_reader :project, :service, :cloud_project, :instance_template, :compute_zone

  def self.publish(project)
    publisher = self.new(project)
    instance = "#{publisher.instance_template}-#{project.id}"

    self.new(project).insert_instance(instance)
    project.deployments.create!(instance: instance)
  end

  def initialize(project)
    @project = project
    @service = Google::Apis::ComputeV1::ComputeService.new

    @cloud_project = ENV.fetch("GOOGLE_CLOUD_PROJECT")
    @instance_template = ENV.fetch("COMPUTE_ENGINE_COMPOSITOR_TEMPLATE")
    @compute_zone = ENV.fetch("COMPUTE_ENGINE_ZONE")

    authenticate_service
  end

  def insert_instance(instance)
    compute_instance = Google::Apis::ComputeV1::Instance.new(name: instance)
    template_url = "global/instanceTemplates/#{instance_template}"

    service.insert_instance(
      cloud_project,
      compute_zone,
      compute_instance,
      source_instance_template: template_url
    )
  end

  private

  def authenticate_service
    scopes = ["https://www.googleapis.com/auth/compute"]
    service.authorization = Google::Auth.get_application_default(scopes)
  end
end
