class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :project_messages, id: :uuid, default: "gen_random_uuid()" do |t|
      t.references :project, type: :uuid, null: false, foreign_key: true
      t.integer :name, default: 0
      t.text :detail

      t.timestamps
    end
  end
end
