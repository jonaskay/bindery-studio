class AddNameAndBucketToPublications < ActiveRecord::Migration[6.0]
  class MigrationPublication < ActiveRecord::Base
    self.table_name = :publications
  end

  class MigrationSite < ActiveRecord::Base
    self.table_name = :sites
  end

  def change
    add_column :publications, :name, :string
    add_column :publications, :bucket, :string

    reversible do |dir|
      dir.up do
        MigrationPublication.reset_column_information

        MigrationPublication.find_each do |publication|
          site = MigrationSite.find_by(publication_id: publication.id)
          name = site ? site.name : "publication-#{SecureRandom.uuid}"
          bucket = site ? site.bucket : nil

          publication.update!(name: name, bucket: bucket)
        end

        change_column_null :publications, :name, false
      end
    end
  end
end
