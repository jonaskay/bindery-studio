class Pubsub::Unpublish::MessagesController < Pubsub::BaseController
  def create
    Subscriber.read_from_unpublish(params[:message][:data])
    head :no_content
  end
end
