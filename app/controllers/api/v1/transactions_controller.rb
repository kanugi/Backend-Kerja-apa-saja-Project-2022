class Api::V1::TransactionsController < ApplicationController

  def top_up_points
    receiver = params[:type] == "company" ? Company.find_by_id(params[:id]) : @current_user
    if receiver.nil?
      return render json: {message: "Penerima tidak ditemukan"}, status: :unprocessable_entity
    end
    if Transaction.add_points(receiver, transaction_params)
      return render json: {message: "Berhasil mengirimkan bukti transfer, silakan tunggu 1x24 jam hingga transaksi anda diverivikasi"}, status: :ok
    else
      return render json: {message: "Transaksi gagal"}, status: :unprocessable_entity
    end
  end

  def withdraw_points
    sender = params[:type] == "company" ? Company.find_by_id(params[:id]) : @current_user
    if sender.nil?
      return render json: {message: "Pengirim tidak ditemukan"}, status: :unprocessable_entity
    end
    if params[:amount].to_i < 10
      return render json: {message: "Jumlah penarikan minimal adalah 10 koin"}, status: :bad_request
    end
    if Transaction.withdraw_points(sender, transaction_params)
      return render json: {message: "Berhasil mengajukan penarikan saldo"}, status: :ok
    else
      return render json: {message: "Transaksi gagal"}, status: :unprocessable_entity
    end
  end

  def index
    @user = params[:type] == "user" ? @current_user: Company.find_by_id(params[:id])
    @transactions = Transaction.history(@user, params)
    return render json: @transactions, status: :ok
  end

  private

  def transaction_params
    {
      amount: params[:amount].to_i,
      image: params[:image],
      bank: params[:bank],
      account_number: params[:account_number],
    }
  end
end