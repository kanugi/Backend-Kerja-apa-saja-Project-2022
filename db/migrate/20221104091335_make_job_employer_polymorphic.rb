class MakeJobEmployerPolymorphic < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :employer_type, :string
  end
end
