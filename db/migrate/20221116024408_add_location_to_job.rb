class AddLocationToJob < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :location, :point
    add_column :jobs, :province, :string
    add_column :jobs, :regency, :string
    add_column :jobs, :district, :string
  end
end
