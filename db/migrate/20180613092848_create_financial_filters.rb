class CreateFinancialFilters < ActiveRecord::Migration[5.1]
  def change
    create_table :financial_filters do |t|
      t.string :description
      t.boolean :three_years, default: true
      t.references :project_version, foreign_key: true

      t.timestamps
    end
  end
end
