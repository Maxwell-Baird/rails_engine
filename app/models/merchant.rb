class Merchant < ApplicationRecord
  has_many :item, :dependent => :destroy
  has_many :invoice, :dependent => :destroy
end
