class CreateBanks < ActiveRecord::Migration[7.0]
  def change
    create_table :banks do |t|
      t.string :name
      t.text :logo_bank
      t.string :account_number


      t.timestamps
    end
  end
end
