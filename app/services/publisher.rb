class Publisher
  class Error < StandardError; end

  def self.publish(project)
    instance_template = ENV.fetch("COMPUTE_COMPOSITOR_TEMPLATE")
    instance = "compositor-#{project.id}"

    ComputeEngine.insert_instance(instance, instance_template)
    project.deployments.create!(instance: instance)
  end
end
