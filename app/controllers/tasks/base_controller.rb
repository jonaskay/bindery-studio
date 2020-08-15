class Tasks::BaseController < ActionController::API
  before_action :validate_headers!
  before_action :validate_client!

  private

  def validate_headers!
    cron = request.headers["X-Appengine-Cron"]
    head :bad_request unless cron || cron == "true"
  end

  def validate_client!
    ip = request.remote_ip
    logger.debug("Remote IP: #{ip}")
    logger.debug("Headers: #{request.headers}")
    head :forbidden if ip != "10.0.0.1"
  end
end
