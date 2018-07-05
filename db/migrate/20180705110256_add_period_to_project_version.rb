class AddPeriodToProjectVersion < ActiveRecord::Migration[5.1]
  def change
    add_column :project_versions, :year_1, :integer
    add_column :project_versions, :year_2, :integer
    add_column :project_versions, :year_3, :integer
    add_column :project_versions, :pli, :string
  end
end
