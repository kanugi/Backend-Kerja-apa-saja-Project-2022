class AddDistanceToCheckin < ActiveRecord::Migration[7.0]
  def change
    add_column :check_ins, :distance, :float
  end
end
