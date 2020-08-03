class RemoveBucketFromPublications < ActiveRecord::Migration[6.0]
  def change
    remove_column :publications, :bucket, :string
  end
end
