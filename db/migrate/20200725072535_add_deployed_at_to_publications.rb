class AddDeployedAtToPublications < ActiveRecord::Migration[6.0]
  def change
    add_column :publications, :deployed_at, :datetime
  end
end
