class Company < ApplicationRecord
  has_many :company_users
  has_many :users, through: :company_users
  has_many :sendings, class_name: "Transaction", foreign_key: "sender_id"
  has_many :receivings, class_name: "Transaction", foreign_key: "receiver_id"
  has_many :jobs, class_name: "Job", foreign_key: "employer_id"
  belongs_to :category

  mount_uploader :photo_profile, PhotoProfileUploader

  def points
    total_receivings = Transaction.where(receiver_id: self.id, is_verified: true).sum(:amount)
    total_sendings = Transaction.where(sender_id: self.id, is_verified: true).sum(:amount)
    return total_receivings - total_sendings - self.deposit
  end

  def deposit
    self.jobs.sum(:salary)
  end

  def transfer_points(amount, receiver)
    if self.points >= amount
      Transaction.create(sender: self, receiver: receiver, amount: amount, transaction_type: "Transfer", is_verified: true)
      Notification.create(user: receiver, category: "transaksi", title: "Insentif telah diterima", description: "Anda telah menerima transfer sebesar #{amount} dari #{self.name}")
      return true
    else
      return false
    end
  end

  def transaction_history
    transactions = self.sendings + self.receivings
    return transactions.sort_by { |transaction| transaction.created_at }
  end

  def new_attribute
    {
      id: self.id,
      name: self.name,
      description: self.description,
      total_employer: self.total_employer,
      photo_profile: self.photo_profile,
      address: self.address,
      phone_number: self.phone_number,
      points: self.points,
      category: self.category.name,
      users: self.company_users.map do |company_user|
        {
          name: company_user.user.name,
          email: company_user.user.email,
          role: company_user.role
        }
      end
    }
  end

  def add_member(params)
    @user = User.find_by(email: params[:email])
    if @user.nil?
      return false
    end
    if self.users.include?(@user)
      return false
    end
    @company_user = CompanyUser.new(company_id: self.id, user_id: @user.id, role: 2)
    if @company_user.save
      true
    else
      false
    end
  end

  def remove_member(params)
    @user = User.find_by_id(params[:user_id])
    if CompanyUser.where(company_id: self.id, user_id: @user.id).destroy_all
      true
    else
      false
    end
  end

  def update_member_role(params)
    @user = User.find_by_id(params[:user_id])
    if CompanyUser.where(company_id: self.id, user_id: @user.id).update_all(role: params[:role])
      true
    else
      false
    end
  end

  rails_admin do
    list do
      field :name do
        label "Nama Perusahaan"
      end
      field :description do
        label "Deksripsi Perusahaan"
      end
      field :total_employer do
        label "Jumlah Karyawan"
      end
      field :photo_profile do
        label "Foto Profil"
      end
      field :points do
        label "Poin"
        read_only true
      end
      field :deposit do
        label "Deposit"
        read_only true
      end
      field :address do
        label "Alamat"
      end
      field :phone_number do
        label "Nomor Telepon"
      end
      field :category do
        label "Kategori"
      end
      field :users do
        label "Karyawan"
      end
      field :jobs do
        label "Pekerjaan"
      end
    end
  end
end
