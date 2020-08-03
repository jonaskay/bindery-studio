class DropDelayedJobs < ActiveRecord::Migration[6.0]
  def change
    remove_index :delayed_jobs, column: [:priority, :run_at], name: "delayed_jobs_priority"

    drop_table :delayed_jobs do
      table.integer :priority, default: 0, null: false
      table.integer :attempts, default: 0, null: false
      table.text :handler, null: false
      table.text :last_error
      table.datetime :run_at
      table.datetime :locked_at
      table.datetime :failed_at
      table.string :locked_by
      table.string :queue
      table.timestamps null: true
    end
  end
end
