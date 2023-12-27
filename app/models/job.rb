class Job < ApplicationRecord
  belongs_to :employer, polymorphic: true
  has_many :workers
  belongs_to :category

  has_many :job_applications, dependent: :destroy
  has_one :room, dependent: :destroy

  validates :status, :title, :description, :duration, :salary, :contact, presence: true

  enum status: {"Belum dikerjakan": 0, "Sedang dikerjakan": 1, "Selesai": 2}

  def name
    self.title ? self.title : ""
  end
  def self.display_all(params)
    page = params[:page].present? ? params[:page].to_i : 1
    per_page = params[:per_page].present? ? params[:per_page].to_i : 10
    status = params[:status]
    category_id = params[:category_id]
    employer_id = params[:employer_id]
    title = params[:title]
    has_applier = params[:has_applier]
    worker_id = params[:worker_id]

    condition = {}
    condition[:status] = status if status.present?
    condition[:category_id] = category_id if  category_id.present?
    condition[:employer_id] = employer_id if employer_id.present?
    search = ["LOWER(title) LIKE ?", "%#{title.downcase}%"] if title.present?
    has_applier = params[:has_applier].present? ? params[:has_applier] : false

    if has_applier == "true"
      has_applier_condition = "id IN (SELECT job_id FROM job_applications)"
    elsif has_applier == "false"
      has_applier_condition = "id NOT IN (SELECT job_id FROM job_applications)"
    else
      has_applier_condition = ""
    end

    if worker_id.present?
      worker_condition = "id IN (SELECT job_id FROM workers WHERE user_id = #{worker_id})"
    else
      worker_condition = ""
    end

    jobs = Job.where(condition).where(search).where(has_applier_condition)
              .where(worker_condition)
              .order(:updated_at).paginate(page: page, per_page: per_page).reverse_order

    return {
      page: page,
      total_page: jobs.total_pages,
      total_items: jobs.total_entries,
      current_page: jobs.current_page,
      data: jobs.map { |job| job.new_attribute.merge("total_applier": job.job_applications.count ) }
    }
  end

  def unfinished_works
    self.man_power - self.workers.where(status: 3).count
  end

  def deposit
    self.salary * self.unfinished_works
  end

  def man_power_needed
    self.man_power - self.workers.where("status < 4").count
  end

  def new_attribute
      {
          id: self.id,
          status: self.status,
          title: self.title,
          description: self.description,
          duration: self.duration,
          salary: self.salary,
          address_point: {
              province: self.province,
              regency: self.regency,
              district: self.district,
          },
          address: self.address,
          location: self.location,
          man_power: self.man_power,
          man_power_needed: self.man_power_needed,
          contact: self.contact,
          employer: self.employer,
          workers: self.workers,
          total_worker: self.man_power - self.man_power_needed,
          category: self.category.name,
          total_applier: self.job_applications.count,
          created_at: self.created_at,
          updated_at: self.updated_at
      }    
  end

  def save_and_create_room
    self.room = Room.new(job: self)
    if self.employer_type == "User"
      self.room.users << self.employer
    elsif self.employer_type == "Company"
      employer.users.each do |user|
        self.room.users << user
      end
    end
    if self.save
      return true
    else
      return false
    end
  end

  def assign_worker(user)
      self.status = "Sedang dikerjakan"
      worker = Worker.new(user: user, job: self, status: 1)
      self.room.users << user
      binding.pry
      Notification.create(user: user, category: "Pekerjaan", title: "Pekerjaan baru", description: "Anda telah diterima untuk bekerja sebagai #{self.title}")
      if worker.save && self.save
          return true
      else
          return false
      end
  end

  def finish_job
      Job.transaction do
          self.status = "Selesai"
          Notification.create(user: self.worker, category: "Pekerjaan", title: "Pekerjaan selesai", description: "Pekerjaan #{self.title} telah selesai")
          self.save
          return true
      rescue ActiveRecord::RecordInvalid => e
          raise ActiveRecord::Rollback
          return false
      end
  end

  rails_admin do
    label "Pekerjaan"
    label_plural "Pekerjaan"

    field :id do
      label "ID"
    end
    field :title do
      "judul pekerjaan"
    end
    field :status do
      label "Status"
    end
    field :employer do
      label "Pemilik"
    end
    field :man_power do
      label "Kebutuhan Tenaga Kerja"
    end
    field :man_power_needed do
      label "Kekurangan Tenaga Kerja"
    end
    field :workers do
      label "Pekerja"
    end
    field :unfinished_works do
      label "Tenaga Kerja yang belum selesai"
    end
    field :description do
      label "Deskripsi"
    end
    field :duration do
      label "Durasi"
    end
    field :salary do
      label "Gaji per pekerja"
    end
    field :deposit do
      label "Total Deposit"
    end
    field :address do
      label "Alamat"
    end
    field :location do
      label "Lokasi"
    end
    field :contact do
      label "Kontak"
    end
    field :job_applications do
      label "Pelamar"
    end
    field :category do
      label "Kategori"
    end
  end
end
