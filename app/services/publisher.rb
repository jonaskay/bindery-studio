require 'googleauth'
require 'google/apis/compute_v1'

class Publisher
  SCOPES = ["https://www.googleapis.com/auth/compute"]

  def initialize(options = {})
    @project = options.fetch(:project, Rails.application.credentials.gcp.fetch(:project))
    @zone = options.fetch(:zone, Rails.application.credentials.gcp.fetch(:zone))
  end

  def self.publish
    self.new.publish
  end

  def publish
    service = Google::Apis::ComputeV1::ComputeService.new
    service.authorization = Google::Auth.get_application_default(SCOPES)

    name = "site-#{SecureRandom.uuid}"
    instance = Google::Apis::ComputeV1::Instance.new(name: name)

    response = service.insert_instance(
      @project,
      @zone,
      instance,
      source_instance_template: source_instance_template
    )

    return name
  end

  private

  def source_instance_template
    instance_template = Rails.application.credentials.gcp.fetch(:instance_template)

    "global/instanceTemplates/#{instance_template}"
  end
end
