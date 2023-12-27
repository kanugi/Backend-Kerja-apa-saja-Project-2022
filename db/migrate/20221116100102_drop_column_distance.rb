class DropColumnDistance < ActiveRecord::Migration[7.0]
  def change
    remove_column :check_ins, :distance
  end
end
