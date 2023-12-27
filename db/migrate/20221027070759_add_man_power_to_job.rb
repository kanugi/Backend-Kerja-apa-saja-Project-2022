class AddManPowerToJob < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :man_power, :integer
  end
end
