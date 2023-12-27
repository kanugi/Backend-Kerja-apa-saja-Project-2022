class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.integer :category_id
      t.string :phone_number
      t.string :address
      t.string :total_employer
      t.string :description

      t.timestamps
    end
  end
end
