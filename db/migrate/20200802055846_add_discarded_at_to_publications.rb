class AddDiscardedAtToPublications < ActiveRecord::Migration[6.0]
  def change
    add_column :publications, :discarded_at, :datetime
    add_index :publications, :discarded_at
  end
end
