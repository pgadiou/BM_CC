class ChangeCompaniesFields < ActiveRecord::Migration[5.1]
  def change
    rename_column :companies, :"Trade description (English)", :trade_description_en
    rename_column :companies, :"Trade description (original language)", :trade_description_original
  end
end
