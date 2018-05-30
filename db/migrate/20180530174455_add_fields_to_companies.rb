class AddFieldsToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :address, :string
    add_column :companies, :website , :string
    add_column :companies, :city , :string
    add_column :companies, :BVD  , :string
    add_column :companies, :website , :integer

  end
end
