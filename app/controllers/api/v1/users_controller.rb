class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :forgot_password, :reset_password]
  before_action :set_user, only: [:update, :change_password, :upload_photo, :change_user_type]

  # GET /api/v1/users
  def index
    @users = User.display_all(params)
    render json: @users, status: :ok
  end

  # POST /api/v1/users
  def create
    if user_params[:password] != user_params[:password_confirmation]
      return render json: {message: "kata sandi dan konfirmasi kata sandi berbeda"}, status: :bad_request
    end

    @user = User.new(user_params)

    if @user.save
      render json: @user.new_attribute, status: :created
    else
      render json: {message: "pendaftaran gagal",
                    errors: @user.errors.full_messages
      }, status: :bad_request
    end
  end

  # GET /api/v1/users/{id}
  def show
    @user = User.find(params[:id])
    render json: @user.new_attribute
  end

  def get_current_user
    render json: {
      user: @current_user.new_attribute,
      companies: @current_user.companies.each { |company| company.new_attribute },
    }, status: :ok
  end

  # PUT /api/v1/users/{id}
  def update
    if @user.update(update_params)
      render json: @user.new_attribute
    else
      render json: {message: "user not updated",
                    errors: @user.errors.full_messages,
      }, status: :bad_request
    end
  end

  # PUT /api/v1/users/{id}/change_password
  def change_password
    if @user.change_password(params[:current_password], params[:new_password])
      render json: {message: "kata sandi berhasil diubah"}, status: :ok
    else
      render json: {message: "gagal mengubah kata sandi",
                    errors: @user.errors.full_messages
      }, status: :bad_request
    end
  end

  def forgot_password
    if params[:email].blank?
      return render json: {message: "email wajib diisi"}, status: :bad_request
    end

    @user = User.find_by(email: params[:email])
    if @user.present?
      @user.generate_password_token!
      PasswordMailer.reset_password(@user).deliver_now
      return render json: {message: "kami telah mengirimkan email untuk mereset kata sandi"}, status: :ok
    else
      return render json: {message: "email tidak ditemukan"}, status: :not_found
    end
  end

  def reset_password
    token = params[:token].to_s
    @user = User.find_by(reset_password_token: token)
    if @user.present? && @user.password_token_valid?
      if @user.reset_password(params[:password], params[:password_confirmation])
        render json: {message: "Kata sandi berhasil direset"}, status: :ok
      else
        render json: {message: "gagal mereset kata sandi", errors: user.errors.full_messages}, status: :bad_request
      end
    else
      render json: {message: "Token tidak valid"}, status: :bad_request
    end
  end

  # PUT /api/v1/users/{id}/upload_photo
  def upload_photo
    photo_profile = params[:photo_profile]
    if photo_profile.nil?
      return render json: {message: "photo_profile wajib diisi",
                           errors: user.errors.full_messages
      }, status: :bad_request
    end

    if @user.update(photo_profile: photo_profile)
      return render json: @user.new_attribute, status: :ok
    else
      return render json: {message: "gagal mengunggah foto profil",
                           errors: user.errors.full_messages
      }, status: :bad_request
    end
  end

  # PUT /api/v1/users/{id}/change_type
  def change_user_type
    if @user.update(user_type: params[:user_type])
      return render json: @user.new_attribute, status: :ok
    else
      return render json: {message: "gagal mengubah tipe user",
                           errors: @user.errors.full_messages
      }, status: :bad_request
    end
  end

  # DELETE /api/v1/users/{id}
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      render json: {message: "user deleted"}, status: :ok
    else
      render json: {message: "user not deleted",
                    errors: @user.errors.full_messages
      }, status: :bad_request
    end
  end

  def activity_histories
    binding.pry
    if @current_user.user_type == 'Worker'
      @activities = @current_user.worker_histories
    else
      @activities = @current_user.employer_histories
    end

    return render json: @activities, status: :ok
  end

  private

  def set_user
    user_id = params[:id].present? ? params[:id].to_i : params[:user_id].to_i
    @user = User.find(user_id)
    if @user.nil?
      return render json: {message: "user not found"}, status: :not_found
    end

    if @user.id != @current_user.id
      return render json: {message: "user tidak dapat mengubah data user lain"}, status: :unauthorized
    end
  end
  def user_params
    {
      name: params[:name],
      email: params[:email],
      phone_number: params[:phone_number],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      dob: params[:dob],
      user_type: params[:user_type],
    }
  end
  def update_params
    {
      name: params[:name],
      dob: params[:dob],
      phone_number: params[:phone_number],
      province: params[:province],
      regency: params[:regency],
      district: params[:district],
    }
  end
end
