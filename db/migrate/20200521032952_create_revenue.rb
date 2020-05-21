class CreateRevenue < ActiveRecord::Migration[5.2]
  def change
    create_table :revenues do |t|
      t.float :revenue
    end
  end
end
