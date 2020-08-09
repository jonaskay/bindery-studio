class Subscriber
  attr_reader :message, :project

  def self.read_from_deploy(encoded_data)
    subscriber = Subscriber.new(encoded_data)
    message = subscriber.message
    project = subscriber.project

    unless message.error_data.empty?
      message.error_data.each do |error_item|
        project.messages.create(name: :error, detail: error_item.message)
      end

      return false
    end

    project.confirm_deployment(message.timestamp)
  end

  def self.read_from_cleanup(encoded_data)
    subscriber = Subscriber.new(encoded_data)
    project = subscriber.project

    project.confirm_cleanup
  end

  def initialize(encoded_data)
    @message = Pubsub::Message.from_encoded(encoded_data)
    @message.validate!

    @project = Project.find(@message.project.id)
  end
end
