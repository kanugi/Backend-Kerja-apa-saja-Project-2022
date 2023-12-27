class Api::V1::JobsController < ApplicationController
    skip_before_action :authenticate_request, only: [:show, :index]
    before_action :set_job, only: [:show, :update, :destroy, :workers]

    def index
        @jobs = Job.display_all(params)
        return render json: @jobs, status: :ok
    end
    
    def show
        render json: @job.new_attribute
    end
    
    def create
        @job = Job.new(job_params)
        @employer = params[:employer_type] == "company" ?  Company.find_by_id(params[:employer_id]) : @current_user
        if @employer.nil?
            return render json: {"message": "Perekrut tidak ditemukan"}, status: :not_found
        end

        @job.employer = @employer

        if @job.employer.points < (@job.salary * @job.man_power)
            return render json: {"message": "Poin anda tidak mencukupi untuk membuat pekerjaan"}, status: :unprocessable_entity
        end
        if @job.save_and_create_room
            Room.create(job: @job)
            render json: @job.new_attribute, status: :created
        else
            render json: {"message": @job.errors.full_messages}, status: :bad_request
        end
    end
    
    def update
        @job = Job.find(params[:id])
        if @job.update(job_params)
            render json: @job.new_attribute, status: :ok
        else
            render json: {"message": "Pekerjaan gagal terupdate"}, status: :unprocessable_entity
        end
    end
    
    def destroy
        @job = Job.find(params[:id])
        if @job.destroy
            render json: {"message": "Pekerjaan Terhapus"}, status: :ok
        else
            render json: {"message": "Pekerjaan tidak terhapus"}, status: :ok
        end
    end

    def workers
        @workers = @job.workers
        render json: @workers, status: :ok
    end
    
    private

    def set_job
        job_id = params[:id] || params[:job_id]
        @job = Job.find_by_id(job_id)
        if @job.nil?
            return render json: {message: "Pekerjaan tidak ditemukan"}, status: :not_found
        end
    end
    
    def job_params
        {
            title: params[:title],
            status: params[:status],
            description: params[:description],
            man_power: params[:man_power],
            duration: params[:duration],
            salary: params[:salary],
            address: params[:address],
            province: params[:province],
            regency: params[:regency],
            district: params[:district],
            location: params[:x] + "," + params[:y],
            contact: params[:contact],
            category_id: params[:category_id],
        }
    end
end
