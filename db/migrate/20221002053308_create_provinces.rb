class CreateProvinces < ActiveRecord::Migration[7.0]
  def self.up
    create_table :provinces, id: false do |t|
      t.integer :code, null: false, primary: true
      t.string :name, null: false
    end
  end

  def self.down
    drop_table :provinces
  end
end
