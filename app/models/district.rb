class District < ActiveRecord::Base
  self.primary_key = 'code'

  belongs_to :regency, foreign_key: :regency_code
  delegate :province, to: :regency

  def new_attribute
    {
      code: self.code,
      name: self.name,
    }
  end
end
