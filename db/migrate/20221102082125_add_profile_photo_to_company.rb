class AddProfilePhotoToCompany < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :photo_profile, :string
  end
end
