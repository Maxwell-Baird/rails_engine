class Api::V1::Merchants::MostItemsController < ApplicationController

  def show
    merchants = Merchant.order(sold: :desc).limit(params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end

end
