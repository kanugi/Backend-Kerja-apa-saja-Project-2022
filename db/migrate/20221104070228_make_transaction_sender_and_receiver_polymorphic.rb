class MakeTransactionSenderAndReceiverPolymorphic < ActiveRecord::Migration[7.0]
  def change
    remove_column :transactions, :sender_id
    remove_column :transactions, :receiver_id
    add_column :transactions, :sender_id, :integer
    add_column :transactions, :sender_type, :string
    add_column :transactions, :receiver_id, :integer
    add_column :transactions, :receiver_type, :string
  end
end
