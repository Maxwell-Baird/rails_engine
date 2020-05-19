require 'rails_helper'

describe "Item API" do
  it "sends a list of items" do
    merchant = create(:merchant)
    create_list(:item, 3, merchant_id: merchant.id)


    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)
    expect(items['data'].count).to eq(3)
  end

  it "can get one item by its id" do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id


    get "/api/v1/items/#{id}"

    expect(response).to be_successful

    item = JSON.parse(response.body)
    expect(item['data']['attributes']['id']).to eq(id)
  end


  it "can create a new item" do
    merchant = create(:merchant)

    item_params = { name: "Apple",
                    description: "It's an apple",
                    unit_price: 12.25,
                    merchant_id: merchant.id}

    post "/api/v1/items", params: item_params
    item = Item.last
    expect(response).to be_successful
    expect(item.name).to eq(item_params[:name])
  end

  it "can update an existing item" do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id

    previous_name = Item.last.name
    item_params = { name: "Cheese",
                    description: "It's an apple",
                    unit_price: 12.25,
                    merchant_id: merchant.id}

    put "/api/v1/items/#{id}", params: item_params
    item = Item.find_by(id: id)
    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Cheese")
  end

  it "can destroy an item" do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id
    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
