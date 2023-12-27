class CreateProgresses < ActiveRecord::Migration[7.0]
  def change
    create_table :progresses do |t|
      t.text :photo_before_progress
      t.text :photo_after_progress
      t.text :description
      t.integer :check_in_id

      t.timestamps
    end
  end
end
