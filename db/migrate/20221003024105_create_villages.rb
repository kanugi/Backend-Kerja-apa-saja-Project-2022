class CreateVillages < ActiveRecord::Migration[7.0]
  def change
    create_table :villages, id: false do |t|
      t.bigint :code, null: false, primary: true
      t.integer :district_code, null: false
      t.string :name, null: false
    end

    add_index :villages, :district_code
  end
end
