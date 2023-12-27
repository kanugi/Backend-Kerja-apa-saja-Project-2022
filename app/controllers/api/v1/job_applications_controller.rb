class Api::V1::JobApplicationsController < ApplicationController
  before_action :set_job_application, only: [:show, :destroy]

  # GET /job_applications
  def index
    @job_applications = JobApplication.display_all(params)

    render json: @job_applications
  end

  # GET /job_applications/1
  def show
    render json: @job_application.new_attribute
  end

  # POST /job_applications
  def create
    @job = Job.find_by_id(params[:job_id])

    return render json: {message: "Job Not found"}, status: :not_found if @job.nil?

    @job_application = JobApplication.new
    @job_application.job_id = @job.id
    @job_application.user_id = @current_user.id
    @job_application.status = 0

    if @current_user == @job.employer
      return render json: {"message": "perekrut tidak bisa melamar di pekerjaan sendiri"}
    end

    if @current_user.job_applications.where(job_id: @job_application.job_id).length > 0
      return render json: {"message": "You have already applied for this job"}, status: :bad_request
    end

    if @job_application.save
      Notification.create(user: @job_application.job.employer, category: "Pekerjaan", title: "Pekerjaan baru", description: "#{@current_user.name} telah mendaftar untuk pekerjaan #{@job_application.job.title}")
      render json: @job_application.new_attribute, status: :created
    else
      render json: @job_application.errors, status: :unprocessable_entity
    end
  end

  def update_status
    @job_application = JobApplication.find(params[:job_application_id])

    if @job_application.nil?
      return render json: {message: "Job Application Not found"}, status: :not_found
    end

    if @job_application.update_status(params)
      render json: @job_application.new_attribute, status: :ok
    else
      render json: @job_application.errors, status: :unprocessable_entity
    end
  end

  def accept_worker
    @job_application = JobApplication.find_by_id(params[:job_application_id])
    if @job_application.nil?
      return render json: {message: "Job Application Not found"}, status: :not_found
    end

    if @job_application.status != "pending"
      return render json: {message: "status lamaran pekerjaan tidak dapat diubah"}, status: :bad_request
    end

    if @job_application.job.employer.id != @current_user.id
      return render json: {message: "Unauthorized"}, status: :unauthorized
    end

    existedWorker = Worker.where(job_id: @job_application.job_id, user_id: @job_application.user_id).first
    if existedWorker.present?
      return render json: {message: "Worker already accepted"}, status: :bad_request
    end

    if @job_application.job.man_power_needed == 0
      return render json: {message: "Job is full"}, status: :bad_request
    end

    if @job_application.accept_worker
      render json: @job_application.new_attribute, status: :ok
    else
      render json: @job_application.errors, status: :unprocessable_entity
    end
  end

  def reject_worker
    @job_application = JobApplication.find_by_id(params[:job_application_id])
    if @job_application.nil?
      return render json: {message: "Job Application Not found"}, status: :not_found
    end

    if @job_application.status != "pending"
      return render json: {message: "status lamaran pekerjaan tidak dapat diubah"}, status: :bad_request
    end

    if @job_application.job.employer.id != @current_user.id
      return render json: {message: "Unauthorized"}, status: :unauthorized
    end

    if @job_application.decline_worker
      render json: @job_application.new_attribute, status: :ok
    else
      render json: @job_application.errors, status: :unprocessable_entity
    end
  end

  # DELETE /job_applications/1
  def destroy
    if @current_user.id != @job_application.user_id
      return render json: {message: "Unauthorized"}, status: :unauthorized
    end
    @job_application.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_application
      @job_application = JobApplication.find(params[:id])
      if @job_application.nil?
        return render json: {message: "Job Application Not found"}, status: :not_found
      end
    end

    # Only allow a trusted parameter "white list" through.
    def job_application_params
      params.require(:job_application).permit(:job_id)
    end
end
