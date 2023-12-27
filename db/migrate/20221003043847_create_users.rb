class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.boolean :is_company, default: false
      t.date :dob
      t.string :phone_number
      t.string :province
      t.string :regency
      t.string :district
      t.string :village

      t.timestamps
    end
  end
end
