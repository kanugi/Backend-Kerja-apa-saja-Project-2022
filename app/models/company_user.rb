class CompanyUser < ApplicationRecord
  belongs_to :user
  belongs_to :company

  enum role: { "owner": 1, "admin": 2 }
end
