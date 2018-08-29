class ChangeYearsNameCompanies < ActiveRecord::Migration[5.1]
  def change
    rename_column :companies, :"Turnover 2011", :turnover_year_1
    rename_column :companies, :"Turnover 2012", :turnover_year_2
    rename_column :companies, :"Turnover 2013", :turnover_year_3
    rename_column :companies, :"EBIT 2011", :EBIT_year_1
    rename_column :companies, :"EBIT 2012", :EBIT_year_2
    rename_column :companies, :"EBIT 2013", :EBIT_year_3
  end
end
