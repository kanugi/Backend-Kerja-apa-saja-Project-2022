class Api::V1::NotificationsController < ApplicationController
  def index
    @notifications = Notification.display_all(params, @current_user)
    render json: @notifications
  end
end
