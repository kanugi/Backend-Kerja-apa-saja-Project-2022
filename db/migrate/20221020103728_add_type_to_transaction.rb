class AddTypeToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :type, :integer
  end
end
