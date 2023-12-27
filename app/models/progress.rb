class Progress < ApplicationRecord
    belongs_to :worker, dependent: :destroy

    validates :description, presence: true

    mount_uploader :photo_before_progress, ImageUploader
    mount_uploader :photo_after_progress, ImageUploader

    def new_attribute 
        {
            id: self.id,
            photo_before_progress: self.photo_before_progress,
            photo_after_progress: self.photo_after_progress,
            description: self.description,
            worker: self.worker.new_attribute
        }
    end

    def did?
        Progress.where(worker_id: self.worker_id).count > 0
    end

    rails_admin do
        label "Progress"
        label_plural "Progress"

        field :id do 
            label "ID"
        end
        field :photo_before_progress do
            label "Foto Sebelum Progress"
        end
        field :photo_after_progress do
            label "Foto Sesudah Progress"
        end
        field :description do
            label "Deskripsi"
        end
        field :worker do
            label "Pekerja"
        end
    end
end
