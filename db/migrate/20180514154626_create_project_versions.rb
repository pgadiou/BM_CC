class CreateProjectVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :project_versions do |t|
      t.references :project, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
