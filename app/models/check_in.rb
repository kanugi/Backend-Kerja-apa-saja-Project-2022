class CheckIn < ApplicationRecord
    belongs_to :worker

    mount_uploader :photo_check_in, ImageUploader

    def new_attribute 
        {
            id: self.id,
            photo_check_in: self.photo_check_in.url,
            location: self.location,
            worker: self.worker.new_attribute
        }
    end

    def did?
        CheckIn.where(worker_id: self.worker_id).count > 0
    end

    def coordinate
        "x: #{self.location.x}, y: #{self.location.y}"
    end

    rails_admin do
        label "Check In"
        label_plural "Check In"

        field :id do 
            label "ID"
        end
        field :location do
            label "Lokasi"
        end
        field :photo_check_in do
            label "Foto Check In"
        end
        field :worker do
            label "Pekerja"
        end

    end
end

