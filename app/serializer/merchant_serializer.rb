class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name
  has_many :item
  has_many :invoice
end
