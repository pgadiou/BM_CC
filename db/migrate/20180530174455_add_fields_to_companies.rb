class AddFieldsToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :"Company name", :string
    add_column :companies, :"Address", :string
    add_column :companies, :"Website" , :string
    add_column :companies, :"Country", :string
    add_column :companies, :"City", :string
    add_column :companies, :"BvD ID number", :string
    add_column :companies, :"NACE / NAF code", :string
    add_column :companies, :"Trade description (English)", :string
    add_column :companies, :"Trade description (original language)", :string
    add_column :companies, :"Turnover 2011", :integer
    add_column :companies, :"Turnover 2012", :integer
    add_column :companies, :"Turnover 2013", :integer
    add_column :companies, :"EBIT 2011", :integer
    add_column :companies, :"EBIT 2012", :integer
    add_column :companies, :"EBIT 2013", :integer
    add_column :companies, :ros_1, :decimal
    add_column :companies, :ros_2, :decimal
    add_column :companies, :ros_3, :decimal
    add_column :companies, :ros_avg, :decimal
    add_column :companies, :fcmu_1, :decimal
    add_column :companies, :fcmu_2, :decimal
    add_column :companies, :fcmu_3, :decimal
    add_column :companies, :fcmu_avg, :decimal
  end
end
