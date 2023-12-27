class Api::V1::BanksController < ApplicationController

    def create
        @bank = Bank.new(bank_params)
        if Bank.find_by_name(bank_params[:name])
            return render json: {message: "data bank sudah tersedia"}, status: :bad_request
        end 
        if @bank.save
            render json: @bank.new_attribute, status: :created
        else
            render json: @bank.errors.full_messages, status: :bad_request
        end
    end

    def index
        @banks = Bank.all
        render json: @banks
    end

    def show
        @bank = Bank.find(params[:id])
        render json: @bank
    end

    def update
        @bank = Bank.find(params[:id])
        if @bank.update(bank_params)
            render json: @bank.new_attribute, status: :ok
        else
            render json: @bank.errors.full_messages, status: :bad_request
        end
    end

    private

    def bank_params
        {
            name: params[:name],
            account_number: params[:account_number],
            logo_bank: params[:logo_bank],
        }
    end
end