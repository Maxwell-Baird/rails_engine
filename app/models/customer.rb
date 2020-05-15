class Customer < ApplicationRecord
  has_many :invoice, :dependent => :destroy
end
