class ProjectVersion < ApplicationRecord
  belongs_to :project
  has_many :companies
end
