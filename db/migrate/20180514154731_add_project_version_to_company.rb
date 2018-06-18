class AddProjectVersionToCompany < ActiveRecord::Migration[5.1]
  def change
   add_reference :companies, :project_version, foreign_key: true
   remove_reference :companies, :project, foreign_key: true
  end
end
