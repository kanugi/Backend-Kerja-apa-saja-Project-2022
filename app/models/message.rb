class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :content, presence: true

  def new_attribute
    {
      sender: {
        id: user.id,
        name: self.user.name,
        photo_profile: self.user.photo_profile.url
      },
      content: self.content,
      created_at: self.created_at,
    }
  end
end
