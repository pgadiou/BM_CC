class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.references :project, foreign_key: true
      t.boolean :lack_financials
      t.boolean :lack_description
      t.boolean :losses
      t.boolean :unrelated_activity
      t.boolean :lack_information
      t.boolean :unrelated_function
      t.boolean :group
      t.boolean :turnover

      t.timestamps
    end
  end
end
