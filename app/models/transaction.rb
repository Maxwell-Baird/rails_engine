class Transaction < ApplicationRecord
  belongs_to :invoice
  has_many :invoice_item, through: :invoice
end
