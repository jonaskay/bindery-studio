class Project::Message < ApplicationRecord
  belongs_to :project

  enum name: { success: 0, error: 1 }

  validates :name, presence: true
  validates :detail, presence: true
end
