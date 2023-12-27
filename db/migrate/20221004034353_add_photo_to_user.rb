class AddPhotoToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :photo_profile, :text
  end
end
