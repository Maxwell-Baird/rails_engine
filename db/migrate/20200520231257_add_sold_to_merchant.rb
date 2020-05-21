class AddSoldToMerchant < ActiveRecord::Migration[5.2]
  def change
    add_column :merchants, :sold, :integer
  end
end
