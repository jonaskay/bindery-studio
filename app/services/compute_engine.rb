require "googleauth"
require "google/apis/compute_v1"

class ComputeEngine
  attr_reader :cloud_project, :compute_zone, :service

  def self.delete_instance(instance)
    self.new.delete_instance(instance)
  end

  def self.insert_instance(instance, instance_template)
    self.new.insert_instance(instance, instance_template)
  end

  def initialize
    @cloud_project = ENV.fetch("GOOGLE_CLOUD_PROJECT")
    @compute_zone = ENV.fetch("COMPUTE_ZONE")
    @service = Google::Apis::ComputeV1::ComputeService.new

    authenticate_service
  end

  def delete_instance(instance)
    service.delete_instance(
      cloud_project,
      compute_zone,
      instance
    )
  end

  def insert_instance(instance, instance_template)
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
