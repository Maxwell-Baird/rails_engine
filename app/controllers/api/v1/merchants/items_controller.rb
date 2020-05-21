class Api::V1::Merchants::ItemsController < ApplicationController

  def index
    items = Item.where(merchant_id: params[:id])
    render json: ItemSerializer.new(items)
  end
end
