class DeploymentMonitor
  def self.check_healths
    Deployment.pending.find_each do |deployment|
      if deployment.created_at < 1.hour.ago
        deployment.handle_timeout
      end
    end
  end
end
