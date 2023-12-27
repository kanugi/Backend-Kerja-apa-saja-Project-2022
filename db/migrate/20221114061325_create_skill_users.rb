class CreateSkillUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :skill_users do |t|
      t.integer :skill_id, null: false
      t.integer :user_id, null: false
    end
  end
end
