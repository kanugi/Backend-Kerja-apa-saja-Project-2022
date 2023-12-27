class CreateWorkers < ActiveRecord::Migration[7.0]
  def change
    create_table :workers do |t|
      t.integer :user_id
      t.integer :job_id
      t.integer :status

      t.timestamps
    end
  end
end
