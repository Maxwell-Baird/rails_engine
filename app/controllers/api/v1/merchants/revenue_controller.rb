class Api::V1::Merchants::RevenueController < ApplicationController

  def index

    merchants = Merchant.order(revenue: :desc).limit(params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    revenue_object = Revenue.new(revenue: merchant.revenue)
    render json: RevenueSerializer.new(revenue_object)
  end

end
