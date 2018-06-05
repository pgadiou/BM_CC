class AddFieldsToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :company_name, :string
    add_column :companies, :address, :string
    add_column :companies, :website , :string
    add_column :companies, :country , :string
    add_column :companies, :city , :string
    add_column :companies, :bvd_id , :string
    add_column :companies, :nace_code , :string
    add_column :companies, :trade_description_en , :string
    add_column :companies, :trade_description_original , :string
    add_column :companies, :turnover_1 , :integer
    add_column :companies, :turnover_2 , :integer
    add_column :companies, :turnover_3 , :integer
    add_column :companies, :ebit_1 , :integer
    add_column :companies, :ebit_2 , :integer
    add_column :companies, :ebit_3 , :integer
    add_column :companies, :ros_1 , :decimal
    add_column :companies, :ros_2 , :decimal
    add_column :companies, :ros_3 , :decimal
    add_column :companies, :ros_avg , :decimal
    add_column :companies, :fcmu_1 , :decimal
    add_column :companies, :fcmu_2 , :decimal
    add_column :companies, :fcmu_3 , :decimal
    add_column :companies, :fcmu_avg , :decimal


  end
end
