class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_item, :dependent => :destroy
end
