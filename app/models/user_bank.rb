class UserBank < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  belongs_to :bank, foreign_key: "bank_id"

  def self.add_user_bank(params, user)
    bank = Bank.find_by_id(params[:bank_id])
    if bank.nil?
      return false
    end
    user_bank = UserBank.new
    user_bank.bank = bank
    user_bank.user = user
    user_bank.account_number = params[:account_number]
    user_bank.name = params[:name]
    if user_bank.save
      return true
    else
      return false
    end
  end

  def edit_user_bank(params)
    self.account_number = params[:account_number]
    self.name = params[:name]
    if self.save
      return true
    else
      return false
    end
  end

  def new_attribute
    {
      id: self.id,
      user: {
        id: self.user.id,
        name: self.user.name
      },
      bank: {
        id: self.bank.id,
        name: self.bank.name
      },
      account_number: self.account_number,
      account_name: self.name
    }
  end
end
