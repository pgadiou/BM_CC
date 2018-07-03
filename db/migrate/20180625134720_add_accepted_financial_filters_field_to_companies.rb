class AddAcceptedFinancialFiltersFieldToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :accepted_for_manual_review, :boolean, default: true
  end
end
