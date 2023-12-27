class AddColumnNameToUserBank < ActiveRecord::Migration[7.0]
  def change
    add_column :user_banks, :name, :string
  end
end
