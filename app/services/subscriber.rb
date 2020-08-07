class Subscriber
  attr_reader :message, :publication

  def self.read_from_deploy(encoded_data)
    subscriber = Subscriber.new(encoded_data)
    message = subscriber.message
    publication = subscriber.publication

    publication.confirm_deployment(message.timestamp)
  end

  def self.read_from_cleanup(encoded_data)
    subscriber = Subscriber.new(encoded_data)
    publication = subscriber.publication

    publication.confirm_cleanup
  end

  def initialize(encoded_data)
    @message = Pubsub::Message.from_encoded(encoded_data)
    @message.validate!

    @publication = Publication.find(@message.project.id)
  end
end
