class DropSites < ActiveRecord::Migration[6.0]
  def change
    drop_table :sites do |t|
      t.references :publication, null: false, foreign_key: true
      t.string :name
      t.string :bucket

      t.timestamps
    end
  end
end
