class Tasks::BaseController < ActionController::API
  before_action :validate_headers!
  before_action :validate_client!

  private

  def validate_headers!
    cron = request.headers["X-Appengine-Cron"]
    head :bad_request unless cron || cron == "true"
  end

  def validate_client!
    head :forbidden if origin_ip != "0.1.0.1"
  end

  def origin_ip
    if origin = request.env["HTTP_X_FORWARDED_FOR"]
      return origin.match(/^([\d\.]+)/)[1]
    end

    request.remote_ip
  end
end
