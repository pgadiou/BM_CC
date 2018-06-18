class AddTabToProjectVersions < ActiveRecord::Migration[5.1]
  def change
    add_column :project_versions, :open_tab, :string
  end
end
