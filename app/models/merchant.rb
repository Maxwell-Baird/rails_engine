class Merchant < ApplicationRecord
  has_many :item, :dependent => :destroy
  has_many :invoice, :dependent => :destroy

  has_many :transactions,  through: :invoice
  has_many :invoice_item, through: :invoice


  def total_revenue
    transactions.where(result: "success")
    .joins(:invoice_item)
    .sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def items_sold
    transactions.where(result: "success")
    .joins(:invoice_item)
    .sum("invoice_items.quantity")
  end

  def revenue_between_dates(start_of_date, end_of_date)
    invoice.joins(:invoice_item, :transactions).where("invoices.created_at >= '#{start_of_date}' and invoices.created_at <= '#{end_of_date}' and transactions.result = 'success'").sum("invoice_items.quantity * invoice_items.unit_price")
  end
end
