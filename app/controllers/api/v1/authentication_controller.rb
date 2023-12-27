class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  # POST /api/v1/login
  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      access_token = access_token_encode(user_id: @user.id)
      refresh_token = refresh_token_encode(user_id: @user.id)
      render json:{
        access_token: access_token,
        refresh_token: refresh_token,
        user_type: @user.user_type,
        user_id: @user.id
      }
    else
      render json: {message: "unauthorized"}, status: :unauthorized
    end
  end

  def 

  # POST /api/v1/update_token
  def update_token
    refresh_token = params[:refresh_token]
    if refresh_token.nil?
      return render json: {message: "refresh_token is required"}, status: :bad_request
    end

    begin
      decoded_refresh_token = jwt_decode(refresh_token)
    rescue JWT::DecodeError
      return render json: {message: "invalid refresh_token"}, status: :unauthorized
    end

    if decoded_refresh_token[:exp] < Time.now.to_i
      return render json: {message: "refresh_token expired"}, status: :unauthorized
    end

    user_id = decoded_refresh_token[:user_id]

    new_access_token = access_token_encode(user_id: user_id)
    new_refresh_token = refresh_token_encode(user_id: user_id)

    return render json: {
      access_token: new_access_token,
      refresh_token: new_refresh_token
    }, status: :ok
  end
end
