class Pubsub::Publish::MessagesController < Pubsub::BaseController
  def create
    Subscriber.read_from_publish(params[:message][:data])
    head :no_content
  end
end
