class Tasks::DeploymentsController < Tasks::BaseController
  def check
    DeploymentMonitor.check_healths
    head :no_content
  end
end
