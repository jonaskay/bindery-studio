require "google/apis/storage_v1"

class StorageCleanupJob < ApplicationJob
  queue_as :default

  def perform(bucket, folder)
    service = Google::Apis::StorageV1::StorageService.new
    service.authorization = Google::Auth.get_application_default(["https://www.googleapis.com/auth/devstorage.read_write"])

    objects = service.list_objects(bucket, prefix: folder)
    objects.items.each do |item|
      service.delete_object(bucket, item.name)
    end
  end
end
