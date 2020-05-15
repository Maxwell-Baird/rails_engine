require 'csv'

desc "Import data from csv file"
task :import => [:environment] do
  Merchant.destroy_all
  Item.destroy_all
  Customer.destroy_all
  Invoice.destroy_all
  InvoiceItem.destroy_all
  Transaction.destroy_all
  puts "destroy all previous seeds"

  ActiveRecord::Base.connection.tables.each do |t|
    ActiveRecord::Base.connection.reset_pk_sequence!(t)
  end
  puts "reset the database"

   merchants = "./db/data/merchants.csv"

   CSV.foreach(merchants, :headers => :true) do |row|
      merchant = Merchant.new
      merchant.name = row['name']
      merchant.created_at = row['created_at']
      merchant.updated_at = row['updated_at']
      merchant.save!
   end

   puts "Created merchants"

   customers = "./db/data/customers.csv"

   CSV.foreach(customers, :headers => :true) do |row|
      customer = Customer.new
      customer.first_name = row['first_name']
      customer.last_name = row['last_name']
      customer.created_at = row['created_at']
      customer.updated_at = row['updated_at']
      customer.save!
   end
   puts "Created customers"

   items = "./db/data/items.csv"

   CSV.foreach(items, :headers => :true) do |row|
      item = Item.new
      item.name = row['name']
      item.description = row['description']
      price = row['unit_price'].to_f / 100.to_f
      item.unit_price = price
      item.merchant_id = row['merchant_id']
      item.created_at = row['created_at']
      item.updated_at = row['updated_at']
      item.save!
   end

   puts "Created items"

   invoices = "./db/data/invoices.csv"

   CSV.foreach(invoices, :headers => :true) do |row|
      invoice = Invoice.new
      invoice.customer_id = row['customer_id']
      invoice.merchant_id = row['merchant_id']
      invoice.status = row['status']
      invoice.created_at = row['created_at']
      invoice.updated_at = row['updated_at']
      invoice.save!
   end

   puts "Created invoice"

   invoice_items = "./db/data/invoice_items.csv"

   CSV.foreach(invoice_items, :headers => :true) do |row|
      invoice_item = InvoiceItem.new
      invoice_item.item_id = row['item_id']
      invoice_item.invoice_id = row['invoice_id']
      invoice_item.quantity = row['quantity']
      price = row['unit_price'].to_f / 100.to_f
      invoice_item.unit_price = price
      invoice_item.created_at = row['created_at']
      invoice_item.updated_at = row['updated_at']
      invoice_item.save!
   end

   puts 'Created invoice_items'

   transactions = "./db/data/transactions.csv"

   CSV.foreach(transactions, :headers => :true) do |row|
      transaction = Transaction.new
      transaction.invoice_id = row['invoice_id']
      transaction.credit_card_number = row['credit_card_number']
      transaction.result = row['result']
      transaction.created_at = row['created_at']
      transaction.updated_at = row['updated_at']
      transaction.save!
   end

   puts 'Created transactions'

end
