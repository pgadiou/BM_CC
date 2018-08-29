class AddUnsetInternetReviewDefault < ActiveRecord::Migration[5.1]
  def change
    change_column :companies, :unset_internet_review, :boolean, :default => false
  end
end
