class Worker < ApplicationRecord
  belongs_to :user
  belongs_to :job
  has_one :check_in, dependent: :destroy
  has_one :progress, dependent: :destroy

  validates :user_id, :job_id, presence: true

  enum status: { "aktif": 1, "Menunggu verifikasi": 2, "selesai": 3, "dibatalkan": 4 }

  def name
    self.user ? self.user.name : ""
  end

  def new_attribute
    {
      id: self.id,
      user: self.user.new_attribute,
      job: self.job.new_attribute,
      status: self.status,
      check_in: self.check_in.nil? ? nil : self.check_in,
      progress: self.progress.nil? ? nil : self.progress,
      created_at: self.created_at,
      updated_at: self.updated_at
    }
  end

  def self.display_all(params)
    page = params[:page].present? ? params[:page].to_i : 1
    per_page = params[:per_page].present? ? params[:per_page].to_i : 10
    status = params[:status]
    job_id = params[:job_id]
    user_id = params[:user_id]
    employer = User.find_by_id(params[:employer_id])

    employer_condition = employer.nil? ? "" : "job_id IN (SELECT id FROM jobs WHERE employer_id = #{employer.id})"

    condition = {}
    condition[:status] = status if status.present?
    condition[:job_id] = job_id if job_id.present?
    condition[:user_id] = user_id if user_id.present?

    workers = Worker.where(condition).where(employer_condition)
                    .order(:updated_at).paginate(page: page, per_page: per_page)


    return {
      page: page,
      total_page: workers.total_pages,
      total_items: workers.total_entries,
      current_page: workers.current_page,
      data: workers.map { |worker| worker.new_attribute }
    }
  end

  def request_to_finish_job
    valid = true
    valid = false if self.check_in.nil?
    valid = false if self.progress.nil?
    if valid && self.update(status: "Menunggu verifikasi")
      Notification.create(
        user_id: self.job.employer_id,
        title: "Pekerja #{self.user.name} meminta verifikasi pekerjaan",
        description: "Pekerja #{self.user.name} meminta verifikasi pekerjaan",
        category: "Pekerjaan"
      )
      return true
    else
      return false
    end
  end

  def verify_job_finished
    self.status = "selesai"
    Transaction.transfer_points(self)
    if Worker.where(
      job_id: self.job_id,
      status: "aktif"
    ).count == 0
      self.job.status = "Selesai"
    end
    self.save!
    Notification.create(
      user_id: self.user_id,
      title: "Pekerjaan #{self.job.title} telah selesai",
      description: "Pekerjaan #{self.job.title} telah selesai",
      category: "Pekerjaan"
    )
    Notification.create(
      user_id: self.job.employer_id,
      title: "Pekerjaan #{self.job.title} telah selesai",
      description: "Pekerjaan #{self.job.title} telah selesai",
      category: "Pekerjaan"
    )
  end

  def remove_worker
    self.status= 4
    self.job.status = 0
    if self.save && self.job.save
      return true
    else
      return false
    end
  end

  rails_admin do
    label "Pekerja"
    label_plural "Pekerja"

    field :id
    field :user do
      label "Pekerja"
    end
    field :job do
      label "Pekerjaan"
    end
    field :status do
      label "Status"
    end
    field :check_in do
      label "Check In"
    end
    field :progress do
      label "Progres"
    end
  end
end
