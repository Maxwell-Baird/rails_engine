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

  it 'return items related to merchant' do
    merchant_id = create(:merchant).id
    id = create(:item, merchant_id: merchant_id).id

    get "/api/v1/items/#{id}/merchant"
    expect(response).to be_successful
    merchant = JSON.parse(response.body)

    expect(merchant['data']['id']).to eq(merchant_id.to_s)
  end


  it 'can find item by attributes' do
    merchant1 = create(:merchant, name: "will").id
    item1 = create(:item, merchant_id: merchant1, name: "will pot", description: "blue pot")
    merchant2 = create(:merchant, name: "John")

    get '/api/v1/items/find?name=ILL'
    expect(response).to be_successful
    expect_item1 = JSON.parse(response.body)
    expect(expect_item1['data']['attributes']['name']).to eq(item1.name)

    item2 = create(:item, merchant_id: merchant1, name: "John Tea", description: "BLUE TEA")

    get '/api/v1/items/find?name=John&description=blue'
    expect(response).to be_successful
    expect_item2 = JSON.parse(response.body)
    expect(expect_item2['data']['attributes']['name']).to eq(item2.name)
  end

  it 'can find all items by attributes' do
    merchant1 = create(:merchant, name: "will").id
    item1 = create(:item, merchant_id: merchant1, name: "will pot")
    item2 = create(:item, merchant_id: merchant1, name: "William shoes")

    get '/api/v1/items/find_all?name=ILL'
    expect(response).to be_successful
    items = JSON.parse(response.body)
    expect(items['data'].count).to eq(2)
    expect(items['data'][0]['attributes']['name']).to eq(item1.name)
    expect(items['data'][1]['attributes']['name']).to eq(item2.name)

    get '/api/v1/items/find_all?name=XY'
    expect(response).to be_successful
    merchants = JSON.parse(response.body)
    expect(merchants['data'].count).to eq(0)
  end
end
