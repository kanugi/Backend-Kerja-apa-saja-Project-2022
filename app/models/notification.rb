class Notification < ApplicationRecord
  belongs_to :user

  enum category: { "transaksi": 1, "Akun": 2, "Pekerjaan": 3 }

  def self.display_all(params, user)
    page = params[:page].present? ? params[:page].to_i : 1
    per_page = params[:per_page].present? ? params[:per_page].to_i : 10

    notifications = Notification.where(user_id: user.id).order("created_at DESC").paginate(page: page, per_page: per_page)
    return {
      total_items: notifications.total_entries,
      total_page: notifications.total_pages,
      current_page: page,
      per_page: per_page,
      data: { notifications: notifications }
    }
  end

end
