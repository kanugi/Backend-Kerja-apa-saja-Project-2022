class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.integer :status
      t.string :description
      t.string :duration
      t.string :salary
      t.string :address
      t.string :contact
      t.integer :employer_id
      t.integer :worker_id
      t.integer :user_id

      t.timestamps
    end

    # add_index :jobs, :employer_id
    # add_index :jobs, :worker_id
  
  end
end
