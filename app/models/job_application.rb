class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job

  validates :user_id, :job_id, :status, presence: true

  enum :status => { :pending => 0, :accepted => 1, :rejected => 2 }

  def self.display_all(params)
    page = params[:page].present? ? params[:page].to_i : 1
    per_page = params[:per_page].present? ? params[:per_page].to_i : 10
    status = params[:status]
    job = Job.find_by_id(params[:job_id])
    user = User.find_by_id(params[:user_id])

    condition = {}
    condition[:status] = status if status.present?
    condition[:job_id] = job.id if job.present?
    condition[:user_id] = user.id if user.present?

    job_applications = JobApplication.where(condition).order(:updated_at).paginate(page: page, per_page: per_page)

    return {
      page: page,
      total_page: job_applications.total_pages,
      total_items: job_applications.total_entries,
      data: job_applications.map { |job_application| job_application.new_attribute }
    }

  end

  def name
    self.user ? self.user.name : ""
  end

  def accept_worker
    Worker.create(user: self.user, job: self.job, status: 1)
    self.user.rooms << self.job.room
    self.status = 1
    if self.job.man_power_needed == 0
      self.job.status = 1
    end
    if self.save && self.job.save
      Notification.create(user: self.user, category: "Pekerjaan", title: "Pekerjaan diterima", description: "Pekerjaan #{self.job.title} telah diterima")
      return true
    else
      return false
    end
  end

  def decline_worker
    self.status = 2
    if self.save
      Notification.create(user: self.user, category: "Pekerjaan", title: "Pekerjaan ditolak", description: "Pekerjaan #{self.job.title} telah ditolak")
      return true
    else
      return false
    end
  end

  def update_status(params)
    if params[:status] == 1
      Job.transaction do
        self.job.assign_worker(self.user)
        self.status = 1
        self.job.save
        self.save
        return true
      rescue ActiveRecord::RecordInvalid => e
        raise ActiveRecord::Rollback
        return false
      end
    else
      self.status = params[:status]
      if self.save
        Notification.create(user: self.user, category: "Pekerjaan", title: "Pekerjaan ditolak", description: "Pekerjaan #{self.job.title} telah ditolak")
        return true
      else
        return false
      end
    end
  end

  def new_attribute
    {
      id: self.id,
      user: self.user.new_attribute,
      job: {
        id: self.job.id,
        title: self.job.title,
        description: self.job.description,
        duration: self.job.duration,
        salary: self.job.salary,
        employer: self.job.employer ? self.job.employer.new_attribute : nil,
        address: self.job.address,
        category: self.job.category.name
      },
      status: self.status,
      created_at: self.created_at,
      updated_at: self.updated_at
    }
  end

  rails_admin do
    label "Lamaran Pekerjaan"
    label_plural "Lamaran Pekerjaan"

    field :id
    field :name do
      label "Nama"
      read_only true
    end
    field :user do
      label "Pekerja"
    end
    field :job do
      label "Pekerjaan"
    end
    field :status do
      label "Status"
    end
  end
end
