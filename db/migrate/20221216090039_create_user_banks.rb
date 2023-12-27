class CreateUserBanks < ActiveRecord::Migration[7.0]
  def change
    create_table :user_banks do |t|
      t.integer :bank_id
      t.integer :user_id
      t.string :account_number

      t.timestamps
    end
  end
end
