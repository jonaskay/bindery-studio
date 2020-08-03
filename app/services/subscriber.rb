class Subscriber
  attr_reader :message, :publication

  def self.read_from_publish(encoded_data)
    subscriber = Subscriber.new(encoded_data)
    message = subscriber.message
    publication = subscriber.publication

    publication.confirm_deployment(message.timestamp)
  end

  def self.read_from_unpublish(encoded_data)
    subscriber = Subscriber.new(encoded_data)
    message = subscriber.message
    publication = subscriber.publication

    publication.confirm_cleanup
  end

  def initialize(encoded_data)
    @message = Message.from_encoded(encoded_data)
    @message.validate!

    @publication = Publication.find(@message.publication_id)
  end
end
