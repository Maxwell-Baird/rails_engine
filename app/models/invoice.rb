class Invoice < ApplicationRecord
  belongs_to :merchant
  belongs_to :customer
  has_many :invoice_item, :dependent => :destroy
  has_many :transactions, :dependent => :destroy
end
