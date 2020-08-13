class DeploymentMonitor
  def self.check_healths
    Deployment.pending.find_each do |deployment|
      if deployment.created_at < 1.hour.ago
        deployment.handle_failure("Timeout")
      end
    end
  end
end
