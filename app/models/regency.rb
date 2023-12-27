class Regency < ActiveRecord::Base
  self.primary_key = 'code'

  belongs_to :province, foreign_key: :province_code
  has_many :districts, foreign_key: :regency_code

  def new_attribute
    {
      code: self.code,
      name: self.name,
    }
  end
end
