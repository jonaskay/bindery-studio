class CreateDeployments < ActiveRecord::Migration[6.0]
  def change
    create_table :deployments, id: :uuid, default: "gen_random_uuid()" do |t|
      t.references :project, type: :uuid, null: false, foreign_key: true
      t.string :instance
      t.datetime :finished_at
      t.datetime :errored_at
      t.text :error_message

      t.timestamps
    end
  end
end
