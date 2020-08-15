class Subscriber
  attr_reader :message

  def self.read_from_deploy(encoded_data)
    subscriber = Subscriber.new(encoded_data)
    message = subscriber.message
    timestamp = message.timestamp
    project = Project.includes(:deployments).find(message.project.id)
    deployment = project.current_deployment

    unless message.error_data.empty?
      message.error_data.each do |error_item|
        deployment.handle_failure(error_item.message, timestamp)
      end

      return false
    end

    deployment.handle_success(timestamp)
  end

  def self.read_from_cleanup(encoded_data)
    subscriber = Subscriber.new(encoded_data)
    message = subscriber.message
    project = Project.find(message.project.id)

    project.confirm_cleanup
  end

  def initialize(encoded_data)
    @message = Pubsub::Message.from_encoded(encoded_data)
    @message.validate!
  end
end
