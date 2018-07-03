class AddAcceptedFieldsToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :accepted_for_internet_review, :boolean
    add_column :companies, :unset_internet_review, :boolean
    add_column :companies, :comment, :text
    rename_column :companies, :unset, :unset_trade_description
  end
end
