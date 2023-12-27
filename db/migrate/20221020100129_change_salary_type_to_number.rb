class ChangeSalaryTypeToNumber < ActiveRecord::Migration[7.0]
  def change
    change_column :jobs, :salary, :integer, using: 'salary::integer'
  end
end
