class CreateTrasactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :amount

      t.timestamps
    end
  end
end
