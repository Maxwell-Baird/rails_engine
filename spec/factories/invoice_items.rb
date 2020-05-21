FactoryBot.define do
  factory :invoice_item do
    quantity { 4 }
    unit_price { 1.5 }
    invoice { nil }
    item { nil }
    created_at { "2012-03-27" }
    updated_at { "2012-03-27" }
  end
end
