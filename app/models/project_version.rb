class ProjectVersion < ApplicationRecord
  belongs_to :project
  has_many :companies, dependent: :destroy
  has_many :financial_filters, dependent: :destroy
end
