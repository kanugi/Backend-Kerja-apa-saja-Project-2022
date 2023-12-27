class User < ApplicationRecord
  require "securerandom"
  has_secure_password

  has_many :jobs, class_name: "Job", foreign_key: "employer_id"
  has_many :works, class_name: "Worker", foreign_key: "user_id"
  has_many :job_applications, dependent: :destroy
  has_many :sendings, class_name: "Transaction", foreign_key: "sender_id"
  has_many :receivings, class_name: "Transaction", foreign_key: "receiver_id"
  has_many :company_users
  has_many :companies, through: :company_users
  has_many :notifications, dependent: :destroy
  has_many :skill_users, dependent: :destroy
  has_many :skills, through: :skill_users
  has_many :room_users, dependent: :destroy
  has_many :rooms, through: :room_users
  has_many :user_banks
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 4 }
  validates :password_digest, :user_type, presence: true
  # validates :phone_number, presence: true, length: { minimum: 11, maximum: 13 }

  mount_uploader :photo_profile, PhotoProfileUploader

  enum :user_type => { "Worker": 0, "Employer": 1 }

  def self.display_all(params)
    user_type = params[:user_type]
    page = params[:page].present? ? params[:page].to_i : 1
    per_page = params[:per_page].present? ? params[:per_page].to_i : 10
    province = params[:province]
    regency = params[:regency]
    district = params[:district]

    condition = {}
    condition[:user_type] = user_type if user_type.present?
    condition[:province] = province if province.present?
    condition[:regency] = regency if regency.present?
    condition[:district] = district if district.present?

    users = User.where(condition).order(:updated_at).paginate(page: page, per_page: per_page)

    return {
      total_items: users.total_entries,
      total_page: users.total_pages,
      current_page: page,
      per_page: per_page,
      data: {
        users: users.map { |user| user.new_attribute }
      }
    }

  end

  def points
    total_receivings = Transaction.where(receiver_id: self.id, is_verified: true).sum(:amount)
    total_sendings = Transaction.where(sender_id: self.id).sum(:amount)
    return total_receivings - total_sendings - self.deposit
  end

  def deposit
    self.jobs.map { |job| job.deposit }.sum
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

  def change_password(current_password, new_password)
    if self.authenticate(current_password) && self.update(password: new_password)
      return true
    else
      return false
    end
  end

  def reset_password(password, password_confirmation)
    self.update(password: password, password_confirmation: password_confirmation)
    save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + 1.hour) > Time.now
  end

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now
    save!
  end

  def new_attribute
    {
      id: self.id,
      name: self.name,
      photo_profile: self.photo_profile.url,
      email: self.email,
      dob: self.dob,
      user_type: self.user_type,
      phone_number: self.phone_number,
      address: {
        province: self.province,
        regency: self.regency,
        district: self.district,
      },
      points: self.points,
      skills: self.skills.map { |skill| skill.name },
      banks: self.user_banks
    }
  end

  def email_valid?
    if self.email.match(URI::MailTo::EMAIL_REGEXP)
      return true
    else
      return false
    end
  end

  def self.paginate(page, per_page)
    offset = page * per_page
    limit(per_page).offset(offset)
  end

  def self.sort(params)
    if params[:sort].present?
      order(params[:sort])
    else
      order(:id)
    end
  end

  def self.total_items
    all.count
  end

  def self.total_pages(per_page)
    (total_items.to_f / per_page).ceil
  end

  def worker_histories
    workers = self.works.map { |work| {
      type: "pekerjaan",
      id: work.id,
      title: work.job.title,
      address: work.job.address,
      status: work.status,
      photo: work.job.employer.photo_profile.url,
      updated_at: work.updated_at,
    }}
    applications = self.job_applications.map { |application| {
      type: "lamaran",
      id: application.id,
      title: application.job.title,
      address: application.job.address,
      status: application.status,
      photo: application.job.employer.photo_profile.url,
      updated_at: application.updated_at,
    }}
    histories = workers + applications
    return histories.sort_by { |history| history[:updated_at] }.reverse
  end

  def employer_histories
    histories = self.jobs.map { |job| {
      type: "pekerjaan",
      id: job.id,
      title: job.title,
      address: job.address,
      status: job.status,
      photo: self.photo_profile.url,
      updated_at: job.updated_at,
    }}
    return histories.sort_by { |history| history[:updated_at] }.reverse
  end



  rails_admin do
    label "Pengguna"
    label_plural "Pengguna"

    field :id do
      label "ID"
    end
    field :name do
      label "Nama"
    end
    field :email do
      label "Email"
    end
    field :user_type do
      label "Tipe Pengguna"
    end
    field :jobs do
      label "Pekerjaan yang dibuka"
    end
    field :works do
      label "Pekerjaan yang dikerjakan"
    end
    field :points do
      label "Poin"
      read_only true
    end
    field :deposit do
      label "Deposit"
      read_only true
    end
    field :receivings do
      label "Penerimaan"
      read_only true
    end
    field :sendings do
      label "Pengiriman"
      read_only true
    end
    field :photo_profile do
      label "Foto Profil"
    end
    field :phone_number do
      label "Nomor Telepon"
    end
  end

  private
  
  def generate_token
    SecureRandom.hex(5)
  end
end
