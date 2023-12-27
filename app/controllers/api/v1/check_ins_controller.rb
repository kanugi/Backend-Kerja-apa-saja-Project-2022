class Api::V1::CheckInsController < ApplicationController
    skip_before_action :authenticate_request, only: [:create]

    def create
        @check_in = CheckIn.new(check_in_params)
        if @check_in.did?
            return render json: {message: "check in sudah dilakukan"}, status: :bad_request
        end 
        if @check_in.save
            render json: @check_in.new_attribute, status: :created
        else
            render json: @check_in.errors.full_messages, status: :bad_request
        end
    end

    def show
        @check_in = CheckIn.find_by_id(params[:id])
        if @check_in.nil?
            return render json: {message: "check in tidak ditemukan"}, status: :not_found
        end
        render json: @check_in.new_attribute
    end

    private

    def check_in_params
        {
            location: params[:x] + "," + params[:y],
            worker_id: params[:worker_id],
            photo_check_in: params[:photo_check_in]
        }
    end

end
