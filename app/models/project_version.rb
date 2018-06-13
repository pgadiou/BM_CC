class ProjectVersion < ApplicationRecord
  belongs_to :project
  has_many :companies
  has_many :financial_filters
end
