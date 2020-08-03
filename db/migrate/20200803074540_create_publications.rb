class CreatePublications < ActiveRecord::Migration[6.0]
  def change
    create_table :publications, id: :uuid, default: "gen_random_uuid()" do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.string :title
      t.datetime :published_at
      t.datetime :deployed_at
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :publications, :name, unique: true
    add_index :publications, :published_at
    add_index :publications, :discarded_at
  end
end
