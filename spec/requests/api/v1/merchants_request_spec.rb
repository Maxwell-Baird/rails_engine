require 'rails_helper'

describe "Merchant API" do
  it "sends a list of merchants" do

    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants['data'].count).to eq(3)
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)
    expect(response).to be_successful
    expect(merchant['data']['attributes']['id']).to eq(id)
  end

  it "can create a new merchant" do
    merchant_params = { name: "Apple"}

    post "/api/v1/merchants", params: merchant_params
    merchant = Merchant.last
    expect(response).to be_successful
    expect(merchant.name).to eq(merchant_params[:name])
  end

  it "can update an existing merchant" do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = { name: "Apple"}

    put "/api/v1/merchants/#{id}", params: merchant_params
    merchant = Merchant.find_by(id: id)
    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq("Apple")
  end

  it "can destroy a merchant" do
    merchant = create(:merchant)

    expect(Merchant.count).to eq(1)

    delete "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful
    expect(Merchant.count).to eq(0)
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'return items related to merchant' do
    merchant = create(:merchant)
    create_list(:item, 3, merchant_id: merchant.id)

    get "/api/v1/merchants/#{merchant.id}/items"
    expect(response).to be_successful
    items = JSON.parse(response.body)

    expect(items['data'].count).to eq(3)
  end

  it 'can find merchant by attributes' do
    merchant1 = create(:merchant, name: "will")
    merchant2 = create(:merchant, name: "John")

    get '/api/v1/merchants/find?name=ILL'
    expect(response).to be_successful
    merchant = JSON.parse(response.body)
    expect(merchant['data']['attributes']['name']).to eq(merchant1.name)
  end

  it 'can find all merchants by attributes' do
    merchant1 = create(:merchant, name: "will")
    merchant2 = create(:merchant, name: "John")
    merchant3 = create(:merchant, name: "Ill and Sons")
    merchant4 = create(:merchant, name: "Sam, Sarah, and Bob")

    get '/api/v1/merchants/find_all?name=ILL'
    expect(response).to be_successful
    merchants = JSON.parse(response.body)
    expect(merchants['data'].count).to eq(2)
    expect(merchants['data'][0]['attributes']['name']).to eq(merchant1.name)
    expect(merchants['data'][1]['attributes']['name']).to eq(merchant3.name)

    get '/api/v1/merchants/find_all?name=XY'
    expect(response).to be_successful
    merchants = JSON.parse(response.body)
    expect(merchants['data'].count).to eq(0)
  end


  it 'can return top merchants based on revenue' do
    merchant1 = create(:merchant, name: "will")
    merchant2 = create(:merchant, name: "John")
    merchant3 = create(:merchant, name: "Ill and Sons")
    merchant4 = create(:merchant, name: "Sam, Sarah, and Bob")
    customer = create(:customer)
    item1 = create(:item, merchant_id: merchant1.id).id
    item2 = create(:item, merchant_id: merchant2.id).id
    item3 = create(:item, merchant_id: merchant3.id).id
    item4 = create(:item, merchant_id: merchant4.id).id
    invoice1 = create(:invoice, merchant_id: merchant1.id, customer_id: customer.id)
    invoice2 = create(:invoice, merchant_id: merchant2.id, customer_id: customer.id)
    invoice3 = create(:invoice, merchant_id: merchant3.id, customer_id: customer.id)
    invoice4 = create(:invoice, merchant_id: merchant4.id, customer_id: customer.id)
    transaction1 = create(:transaction, invoice_id: invoice1.id)
    transaction2 = create(:transaction, invoice_id: invoice1.id)
    transaction3 = create(:transaction, invoice_id: invoice2.id)
    transaction4 = create(:transaction, invoice_id: invoice2.id, result: "failed")
    transaction5 = create(:transaction, invoice_id: invoice3.id)
    transaction6 = create(:transaction, invoice_id: invoice4.id)
    invoice_item1 = create(:invoice_item, item_id: item1, invoice_id: invoice1.id)
    invoice_item2 = create(:invoice_item, item_id: item2, invoice_id: invoice2.id)
    invoice_item3 = create(:invoice_item, item_id: item3, invoice_id: invoice3.id)
    invoice_item4 = create(:invoice_item, item_id: item4, invoice_id: invoice4.id, unit_price: 10)
    merchant1.update_attribute(:revenue, merchant1.total_revenue)
    merchant2.update_attribute(:revenue, merchant2.total_revenue)
    merchant3.update_attribute(:revenue, merchant3.total_revenue)
    merchant4.update_attribute(:revenue, merchant4.total_revenue)

    get '/api/v1/merchants/most_revenue?quantity=4'
    expect(response).to be_successful
    merchants = JSON.parse(response.body)

    expect(merchants['data'].count).to eq(4)
    expect(merchants['data'][0]['attributes']['name']).to eq(merchant4.name)
    expect(merchants['data'][1]['attributes']['name']).to eq(merchant1.name)
    expect(merchants['data'][2]['attributes']['name']).to eq(merchant2.name)
    expect(merchants['data'][3]['attributes']['name']).to eq(merchant3.name)

  end

  it 'can return top merchants based on quantity' do
    merchant1 = create(:merchant, name: "will")
    merchant2 = create(:merchant, name: "John")
    merchant3 = create(:merchant, name: "Ill and Sons")
    merchant4 = create(:merchant, name: "Sam, Sarah, and Bob")
    customer = create(:customer)
    item1 = create(:item, merchant_id: merchant1.id).id
    item2 = create(:item, merchant_id: merchant2.id).id
    item3 = create(:item, merchant_id: merchant3.id).id
    item4 = create(:item, merchant_id: merchant4.id).id
    invoice1 = create(:invoice, merchant_id: merchant1.id, customer_id: customer.id)
    invoice2 = create(:invoice, merchant_id: merchant2.id, customer_id: customer.id)
    invoice3 = create(:invoice, merchant_id: merchant3.id, customer_id: customer.id)
    invoice4 = create(:invoice, merchant_id: merchant4.id, customer_id: customer.id)
    transaction1 = create(:transaction, invoice_id: invoice1.id)
    transaction2 = create(:transaction, invoice_id: invoice1.id)
    transaction3 = create(:transaction, invoice_id: invoice2.id)
    transaction4 = create(:transaction, invoice_id: invoice2.id, result: "failed")
    transaction5 = create(:transaction, invoice_id: invoice3.id)
    transaction6 = create(:transaction, invoice_id: invoice4.id)
    invoice_item1 = create(:invoice_item, item_id: item1, invoice_id: invoice1.id)
    invoice_item2 = create(:invoice_item, item_id: item2, invoice_id: invoice2.id, quantity: 14)
    invoice_item3 = create(:invoice_item, item_id: item3, invoice_id: invoice3.id, quantity: 150)
    invoice_item4 = create(:invoice_item, item_id: item4, invoice_id: invoice4.id, quantity: 10)
    merchant1.update_attribute(:sold, merchant1.items_sold)
    merchant2.update_attribute(:sold, merchant2.items_sold)
    merchant3.update_attribute(:sold, merchant3.items_sold)
    merchant4.update_attribute(:sold, merchant4.items_sold)

    get "/api/v1/merchants/most_items?quantity=4"
    expect(response).to be_successful
    merchants = JSON.parse(response.body)
    expect(merchants['data'].count).to eq(4)
    expect(merchants['data'][0]['attributes']['name']).to eq(merchant3.name)
    expect(merchants['data'][1]['attributes']['name']).to eq(merchant2.name)
    expect(merchants['data'][2]['attributes']['name']).to eq(merchant4.name)
    expect(merchants['data'][3]['attributes']['name']).to eq(merchant1.name)

  end

  it 'can find revenue between dates' do
    merchant1 = create(:merchant, name: "will")
    merchant2 = create(:merchant, name: "John")
    merchant3 = create(:merchant, name: "Ill and Sons")
    merchant4 = create(:merchant, name: "Sam, Sarah, and Bob")
    customer = create(:customer)
    item1 = create(:item, merchant_id: merchant1.id).id
    item2 = create(:item, merchant_id: merchant2.id).id
    item3 = create(:item, merchant_id: merchant3.id).id
    item4 = create(:item, merchant_id: merchant4.id).id
    invoice1 = create(:invoice, merchant_id: merchant1.id, customer_id: customer.id, created_at: "2012-03-12")
    invoice2 = create(:invoice, merchant_id: merchant2.id, customer_id: customer.id, created_at: "2012-03-13")
    invoice3 = create(:invoice, merchant_id: merchant3.id, customer_id: customer.id, created_at: "2012-03-15")
    invoice4 = create(:invoice, merchant_id: merchant4.id, customer_id: customer.id, created_at: "2012-03-21")
    transaction1 = create(:transaction, invoice_id: invoice1.id)
    transaction2 = create(:transaction, invoice_id: invoice1.id)
    transaction3 = create(:transaction, invoice_id: invoice2.id)
    transaction4 = create(:transaction, invoice_id: invoice2.id, result: "failed")
    transaction5 = create(:transaction, invoice_id: invoice3.id)
    transaction6 = create(:transaction, invoice_id: invoice4.id)
    invoice_item1 = create(:invoice_item, item_id: item1, invoice_id: invoice1.id)
    invoice_item2 = create(:invoice_item, item_id: item2, invoice_id: invoice2.id)
    invoice_item3 = create(:invoice_item, item_id: item3, invoice_id: invoice3.id)
    invoice_item4 = create(:invoice_item, item_id: item4, invoice_id: invoice4.id)
    merchant1.update_attribute(:revenue, merchant1.total_revenue)
    merchant2.update_attribute(:revenue, merchant2.total_revenue)
    merchant3.update_attribute(:revenue, merchant3.total_revenue)
    merchant4.update_attribute(:revenue, merchant4.total_revenue)

    get '/api/v1/revenue?start=2012-03-12&end=2012-03-15'
    expect(response).to be_successful
    merchants = JSON.parse(response.body)
    expect(merchants['data']['attributes']['revenue']).to eq(24.0)

  end

  it 'can find revenue for a merchant' do
    merchant1 = create(:merchant, name: "will")
    merchant2 = create(:merchant, name: "John")
    merchant3 = create(:merchant, name: "Ill and Sons")
    merchant4 = create(:merchant, name: "Sam, Sarah, and Bob")
    customer = create(:customer)
    item1 = create(:item, merchant_id: merchant1.id).id
    item2 = create(:item, merchant_id: merchant2.id).id
    item3 = create(:item, merchant_id: merchant3.id).id
    item4 = create(:item, merchant_id: merchant4.id).id
    invoice1 = create(:invoice, merchant_id: merchant1.id, customer_id: customer.id, created_at: "2012-03-12")
    invoice2 = create(:invoice, merchant_id: merchant2.id, customer_id: customer.id, created_at: "2012-03-13")
    invoice3 = create(:invoice, merchant_id: merchant3.id, customer_id: customer.id, created_at: "2012-03-15")
    invoice4 = create(:invoice, merchant_id: merchant4.id, customer_id: customer.id, created_at: "2012-03-21")
    transaction1 = create(:transaction, invoice_id: invoice1.id)
    transaction2 = create(:transaction, invoice_id: invoice1.id)
    transaction3 = create(:transaction, invoice_id: invoice2.id)
    transaction4 = create(:transaction, invoice_id: invoice2.id, result: "failed")
    transaction5 = create(:transaction, invoice_id: invoice3.id)
    transaction6 = create(:transaction, invoice_id: invoice4.id)
    invoice_item1 = create(:invoice_item, item_id: item1, invoice_id: invoice1.id)
    invoice_item2 = create(:invoice_item, item_id: item2, invoice_id: invoice2.id)
    invoice_item3 = create(:invoice_item, item_id: item3, invoice_id: invoice3.id)
    invoice_item4 = create(:invoice_item, item_id: item4, invoice_id: invoice4.id)
    merchant1.update_attribute(:revenue, merchant1.total_revenue)
    merchant2.update_attribute(:revenue, merchant2.total_revenue)
    merchant3.update_attribute(:revenue, merchant3.total_revenue)
    merchant4.update_attribute(:revenue, merchant4.total_revenue)

    get "/api/v1/merchants/#{merchant1.id}/revenue"
    expect(response).to be_successful
    merchants = JSON.parse(response.body)
    expect(merchants['data']['attributes']['revenue']).to eq(12.0)

  end



end
