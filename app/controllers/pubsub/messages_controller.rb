class Pubsub::MessagesController < ActionController::API
  before_action :validate_bearer_token

  def create
    head :no_content
  end

  private

  def validate_bearer_token
    begin
      token = Authenticator.access_token(request.headers["Authorization"])
      unless Authenticator.validate_token(token)
        head :unauthorized
      end
    rescue Authenticator::Error => err
      head :bad_request
    end
  end
end
