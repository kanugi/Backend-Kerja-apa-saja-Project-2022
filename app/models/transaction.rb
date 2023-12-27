class Transaction < ApplicationRecord
  belongs_to :sender, polymorphic: true, optional: true
  belongs_to :receiver, polymorphic: true, optional: true
  belongs_to :banks, optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :bank, presence: true 

  mount_uploader :image, ImageUploader

  enum :transaction_type => { "Top Up": 0, "Withdraw": 1, "Transfer": 2 }

  def name
    if self.transaction_type == "Top Up"
      return "Top Up #{self.amount}"
    elsif self.transaction_type == "Withdraw"
      return "Withdraw #{self.amount}"
    elsif self.transaction_type == "Transfer"
      return "Transfer #{self.amount}"
    end
  end

  def self.add_points(user, params)
    transaction = Transaction.new(params.merge({receiver: user, transaction_type: "Top Up"}))
    if transaction.save
      return true
    else
      return false
    end
  end

  def self.withdraw_points(user, params)
    transaction = Transaction.create(params.merge({sender: user, transaction_type: "Withdraw"}))
    if user.points >= params[:amount]
      if transaction.save
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def self.transfer_points(work)
    worker = work.user
    employer = work.job.employer
    amount = work.job.salary
    job_title = work.job.title
    transaction = Transaction.create(sender: employer, receiver: worker, account_number: 0, bank:"-",
                                     amount: amount, transaction_type: "Transfer",
                                     is_verified: true)
    if transaction.save
      Notification.create(user: employer,
                          category: "transaksi",
                          title: "Insentif telah diterima",
                          description: "Anda telah menerima transfer sebesar #{amount} dari pekerjaan #{job_title}"
      )
      return true
    else
      return transaction.errors.full_messages
    end

  end

  def self.history(user, params)
    page = params[:page].to_i || 1
    per_page = params[:per_page].to_i || 10
    transactions = Transaction.where("sender_id = ? or receiver_id = ?", user.id, user.id)
                              .order("created_at DESC").paginate(page: page, per_page: per_page)
    return {
      total_items: transactions.total_entries,
      total_page: transactions.total_pages,
      current_page: page,
      per_page: per_page,
      transactions: transactions
    }
  end

  rails_admin do
    label "Transaksi"
    label_plural "Transaksi"

    field :id
    field :transaction_type do
      label "Jenis Transaksi"
    end
    field :name do
      label "Nama"
      read_only true
    end
    field :sender do
      label "Pengirim"
    end
    field :receiver do
      label "Penerima"
    end
    field :amount do
      label "Jumlah"
    end
    field :image do
      label "Bukti"
    end
    field :bank do
      label "Bank"
      read_only true
    end
    field :account_number do
      label "Nomor Rekening"
      read_only true
    end
    field :is_verified do
      label "Terverifikasi"
    end

    field :created_at do
      label "Tanggal Transaksi"
      read_only true
    end
  end
end
