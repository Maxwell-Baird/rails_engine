class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :item, :created_at, :updated_at, :revenue

  has_many :invoice
end
