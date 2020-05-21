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
      Merchant.create(name: row['name'],
                      created_at: row['created_at'][0...10],
                      updated_at: row['updated_at'][0...10])
   end

   puts "Created merchants"

   customers = "./db/data/customers.csv"

   CSV.foreach(customers, :headers => :true) do |row|
      Customer.create(first_name: row['first_name'],
                      last_name: row['last_name'],
                      created_at: row['created_at'][0...10],
                      updated_at: row['updated_at'][0...10])
   end
   puts "Created customers"

   items = "./db/data/items.csv"

   CSV.foreach(items, :headers => :true) do |row|
     price = row['unit_price'].to_i / 100.00
     Item.create(name: row['name'],
                  description: row['description'],
                  unit_price: price,
                  merchant_id: row['merchant_id'],
                  created_at: row['created_at'][0...10],
                  updated_at: row['updated_at'][0...10])
   end

   puts "Created items"

   invoices = "./db/data/invoices.csv"

   CSV.foreach(invoices, :headers => :true) do |row|
     Invoice.create(customer_id: row['customer_id'],
                    merchant_id: row['merchant_id'],
                    status: row['status'],
                    created_at: row['created_at'][0...10],
                    updated_at: row['updated_at'][0...10])
   end

   puts "Created invoice"

   invoice_items = "./db/data/invoice_items.csv"

   CSV.foreach(invoice_items, :headers => :true) do |row|
     price = row['unit_price'].to_i / 100.00
     InvoiceItem.create(item_id: row['item_id'],
                        invoice_id: row['invoice_id'],
                        quantity: row['quantity'],
                        unit_price: price,
                        created_at: row['created_at'][0...10],
                        updated_at: row['updated_at'][0...10] )
   end

   puts 'Created invoice_items'

   transactions = "./db/data/transactions.csv"

   CSV.foreach(transactions, :headers => :true) do |row|
     Transaction.create(invoice_id: row['invoice_id'],
                        credit_card_number: row['credit_card_number'],
                        result: row['result'],
                        created_at: row['created_at'][0...10],
                        updated_at: row['updated_at'][0...10] )
   end

   puts 'Created transactions'

   Merchant.all.each do |merchant|
     merchant.update_attribute(:revenue, merchant.total_revenue)
     merchant.update_attribute(:sold, merchant.items_sold)
   end
end
