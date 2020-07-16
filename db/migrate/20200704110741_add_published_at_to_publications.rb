class AddPublishedAtToPublications < ActiveRecord::Migration[6.0]
  def change
    add_column :publications, :published_at, :datetime
  end
end
