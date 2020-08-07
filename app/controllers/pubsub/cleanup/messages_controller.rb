class Pubsub::Cleanup::MessagesController < Pubsub::BaseController
  def create
    Subscriber.read_from_cleanup(params[:message][:data])
    head :no_content
  end
end
