require "google/cloud/pubsub"

class Cleaner
  def self.clean(project, pubsub = Google::Cloud::PubSub.new)
    topic = pubsub.topic(ENV.fetch("PUBSUB_CLEANER_TOPIC"))

    message = {
      project: {
        id: project.id,
        name: project.name
      }
    }.to_json

    topic.publish(message)
  end
end
