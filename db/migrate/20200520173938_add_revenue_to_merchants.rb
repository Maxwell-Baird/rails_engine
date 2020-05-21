class AddRevenueToMerchants < ActiveRecord::Migration[5.2]
  def change
    add_column :merchants, :revenue, :float
  end
end
