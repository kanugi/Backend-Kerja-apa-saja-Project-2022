class Api::V1::RoomsController < ApplicationController

  def index
    @rooms = @current_user.rooms.order("updated_at DESC")
    render json: @rooms.map { |room| room.new_attribute }
  end

  def show
    @room = Room.find(params[:id])
    render json: @room.new_attribute
  end
end
