class Skill < ApplicationRecord
    has_many :skill_users, dependent: :destroy
    has_many :users, through: :skill_users
    
    def self.assign_skill(user, skill)
      if SkillUser.create(user: user, skill: skill)
        return true
      else
        return false
      end
    end
  
    def self.search(search)
      Skill.where("lower(name) LIKE ?", "%#{search.downcase}%")
    end
    
    rails_admin do
      label "Kemampuan"
      label_plural "Kemampuan"
  
      field :name do
        label "Skill"
      end
  
      field :users do
        label "Pengguna"
      end
    end
    
  end
  