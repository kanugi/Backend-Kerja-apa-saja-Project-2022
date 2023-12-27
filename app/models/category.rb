class Category < ApplicationRecord
  has_many :jobs

  validates :name, presence: true, uniqueness: true

  rails_admin do
    label "Kategori"
    label_plural "Kategori"

    list do
      sort_by :name
    end

    field :name do
      label "Nama"
    end
    field :jobs do
      label "Pekerjaan"
    end
  end
end
