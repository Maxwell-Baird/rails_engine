FactoryBot.define do
  factory :transaction do
    result { "success" }
    credit_card_number {'1111'}
    credit_card_expiration_date {''}
    invoice { nil }
    created_at { "2012-03-27" }
    updated_at { "2012-03-27" }
  end
end
