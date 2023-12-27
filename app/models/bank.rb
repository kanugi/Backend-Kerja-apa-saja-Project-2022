class Bank < ApplicationRecord
    has_many :transactions
    has_many :user_banks

    validates :name, presence: true
    validates :account_number, presence: true, numericality: { only_integer: true }, length: { minimum: 10}

    mount_uploader :logo_bank, LogoBankUploader

    def new_attribute
        {
            id: self.id,
            name: self.name,
            account_number: self.account_number,
            logo_bank: self.logo_bank.url
        }
    end

    rails_admin do
        label "Bank"
        label_plural "Bank"

        field :id do 
            label "ID"
        end
        field :name do
            label "Nama"
        end
        field :account_number do
            label "Nomor Rekening"
        end
        field :logo_bank do
            label "Logo Bank"
        end
    end



end
