class Room < ApplicationRecord
  belongs_to :job
  has_many :messages, dependent: :destroy
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users

  def new_attribute
    {
      id: self.id,
      job: self.job.new_attribute,
      messages: self.messages.order("updated_at DESC").map { |message| message.new_attribute },
      users: self.users.map { |user| user.new_attribute },
      last_message: self.last_message ? self.last_message.new_attribute : nil
    }
  end

  def display_all
    self.order(:updated_at)
  end

  def last_message
    self.messages.last
  end
end
