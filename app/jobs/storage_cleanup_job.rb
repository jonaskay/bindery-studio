require "google/cloud/storage"

class StorageCleanupJob < ApplicationJob
  queue_as :default

  def perform(bucket, folder)
    storage = Google::Cloud::Storage.new
    bucket = storage.bucket(bucket)
    files = bucket.files(prefix: folder)
    files.all do |file|
      file.delete
    end
  end
end
