class AddUnsetAcceptedFieldsCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :"accepted", :boolean
    add_column :companies, :"unset", :boolean, default: true
  end
end
