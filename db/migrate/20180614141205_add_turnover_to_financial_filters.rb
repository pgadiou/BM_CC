class AddTurnoverToFinancialFilters < ActiveRecord::Migration[5.1]
  def change
    add_column :financial_filters, :minimum_turnover, :integer
  end
end
