require 'rails_helper'

describe "Item API" do
  skip it "sends a list of items" do
    create_list(:merchant, 1)
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(items.count).to eq(3)
  end
end
