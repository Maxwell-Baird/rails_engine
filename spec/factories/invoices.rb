FactoryBot.define do
  factory :invoice do
    status { "Shipped" }
    customer { nil }
    merchant { nil }
    created_at { "2012-03-27" }
    updated_at { "2012-03-27" }
  end
end
