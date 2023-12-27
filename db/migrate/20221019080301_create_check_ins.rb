class CreateCheckIns < ActiveRecord::Migration[7.0]
  def change
    create_table :check_ins do |t|
      t.text :photo_check_in
      t.point :location
      t.integer :job_id

      t.timestamps
    end
  end
end
