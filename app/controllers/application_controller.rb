class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_request

  private
  def authenticate_request
    header = request.headers["Authorization"]
    if header.nil?
      return render json: {message: "unauthorized"}, status: :unauthorized
    end
    header = header.split(" ").last if header
    decoded = jwt_decode(header)
    if decoded.nil?
      return render json: {message: "unauthorized"}, status: :unauthorized
    end
    if decoded[:exp] < Time.now.to_i
      return render json: {message: "access token expired"}, status: :unauthorized
    end
    @current_user = User.find(decoded[:user_id])
  end
end
