class Pubsub::Deploy::MessagesController < Pubsub::BaseController
  def create
    Subscriber.read_from_deploy(params[:message][:data])
    head :no_content
  end
end
