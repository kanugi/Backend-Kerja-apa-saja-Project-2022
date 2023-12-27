class Api::V1::WorkersController < ApplicationController
  before_action :set_worker, only: [:show, :request_to_finish_job, :verify_job_finished, :destroy]

  def index
    @workers = Worker.display_all(params)
    return render json: @workers, status: :ok
  end

  def show
    return render json: @worker.new_attribute, status: :ok
  end

  def request_to_finish_job
    if @worker.status != "aktif"
      return render json: {message: "pekerjaan telah selesai atau menunggu verifikas"}, status: :bad_request
    end
    if @worker.request_to_finish_job
      return render json: {message: "request to finish job success"}, status: :ok
    else
      return render json: {message: "request to finish job failed"}, status: :bad_request
    end
  end

  def verify_job_finished
    if @worker.job.employer != @current_user
      return render json: {message: "you are not the employer"}, status: :unauthorized
    end
    if @worker.verify_job_finished
      return render json: {message: "verify job finished success"}, status: :ok
    else
      return render json: {message: "verify job finished failed"}, status: :bad_request
    end
  end

  def destroy
    if @worker.remove_worker
      return render json: {message: "pekerjaan berhasil dibatalkan"}, status: :ok
    else
      return render json: {message: "gagal membatalkan pekerjaan"}, status: :unprocessable_entity
    end
  end

  private

  def set_worker
    worker_id = params[:id] || params[:worker_id]
    @worker = Worker.find_by_id(worker_id)
    if @worker.nil?
      return render json: {message: "worker not found"}, status: :not_found
    end
  end
end
