class Api::V1::UserBanksController < ApplicationController
  before_action :set_user_bank, only: [:update, :destroy, :show]


  def index
    return render json: @current_user.user_banks.map { |user_bank| user_bank.new_attribute  }
  end

  def show
    return render json: @user_bank.new_attribute
  end

  def create
    condition= {}
    condition[:user_id] = @current_user.id
    condition[:bank_id] = params[:bank_id]
    user_bank = UserBank.where(condition)
    if user_bank.first.present?
      return render json: {message: "Data rekening untuk bank #{user_bank.first.bank.name} telah ditambahkan"}
    end
    if UserBank.add_user_bank(params, @current_user)
      return render json: {message: "berhasilkan menambahkan data bank"}
    else
      return render json: {message: "gagal memproses data, silakan mencoba beberapa saat lagi"}
    end
  end

  def update
    if @user_bank.edit_user_bank(params)
      return render json: {message: "berhasil memperbarui data bank"}
    else
      return render json: {message: "gagal memperbarui data bank, silakan mencoba beberapa saat lagi"}
    end
  end

  def destroy
    if @user_bank.delete
      return render json: {message: "berhasil menghapus data bank"}
    else
      return render json: {message: "gagal menghapus data bank, silakan mencoba beberapa saat lagi"}
    end
  end

  private

  def set_user_bank
    @user_bank = UserBank.find_by_id(params[:id])
    if @user_bank.nil?
      return render json: {message: "data bank tidak ditemukan"}
    end
  end
end
