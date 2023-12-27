class DropVillageColumnOnUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :village
  end
end
