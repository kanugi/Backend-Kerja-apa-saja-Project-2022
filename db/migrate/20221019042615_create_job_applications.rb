class CreateJobApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :job_applications do |t|
      t.integer :user_id, null: false
      t.integer :job_id, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
