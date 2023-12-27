class AddNotificationCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :category, :integer
  end
end
