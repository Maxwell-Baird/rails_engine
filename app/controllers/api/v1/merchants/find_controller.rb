class Api::V1::Merchants::FindController < ApplicationController

  def index
    render json: MerchantSerializer.new(filter)
  end

  def show
    render json: MerchantSerializer.new(filter[0])
  end

  private

  def merchant_params
    params.permit(:name, :created_at, :updated_at, :id)
  end

  def filter
    merchant_params.to_h.reduce([]) do |output, (attribute, value)|
      output << Merchant.where("#{attribute} ilike ?", "%#{value}%")
    end.flatten.uniq
  end
end
