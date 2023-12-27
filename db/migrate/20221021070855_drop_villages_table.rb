class DropVillagesTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :villages
  end
end
