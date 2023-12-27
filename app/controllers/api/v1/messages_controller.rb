class Api::V1::MessagesController < ApplicationController
  before_action :set_room

  def index
    @messages = @room.messages.order("updated_at DESC").reverse_order
    render json: @messages.map { |message| message.new_attribute }
  end

  def create
    @message = @room.messages.new(message_params)
    @message.user = @current_user
    if @message.save
      render json: @message.new_attribute, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def message_params
    {
      content: params[:content],
      user: @current_user,
      room: @room
    }
  end
end
