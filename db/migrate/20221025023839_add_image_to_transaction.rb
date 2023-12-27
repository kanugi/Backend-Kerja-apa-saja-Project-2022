class AddImageToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :image, :string
    add_column :transactions, :bank, :string
    add_column :transactions, :account_number, :string
    add_column :transactions, :is_verified, :boolean, default: false
  end
end
