class Api::V1::ProgressesController < ApplicationController
    skip_before_action :authenticate_request, only: [:create]

    def create
        @progress = Progress.new(progress_params)
        if @progress.did?
            return render json: {message: "update progress sudah dilakukan"}, status: :bad_request
        end
        if @progress.save
            render json: @progress.new_attribute, status: :created
        else
            render json: @progress.errors.full_messages, status: :bad_request
        end
    end

    def show
        @progress = Progress.find_by_id(params[:id])
        if @progress.nil?
            return render json: {message: "progress tidak ditemukan"}, status: :not_found
        end
        return render json: @progress.new_attribute
    end


    private

    def progress_params
        {
            description: params[:description],
            worker_id: params[:worker_id],
            photo_before_progress: params[:photo_before_progress],
            photo_after_progress: params[:photo_after_progress]
        }
    end

end
