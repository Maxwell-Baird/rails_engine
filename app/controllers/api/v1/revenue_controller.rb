class Api::V1::RevenueController < ApplicationController

  def show
    merchants = Merchant.all
    value = merchants.sum do |merchant|
      merchant.revenue_between_dates(params[:start], params[:end])
    end
    revenue_object = Revenue.new(revenue: value)
    render json: RevenueSerializer.new(revenue_object)
  end

end
