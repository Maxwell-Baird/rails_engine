class Api::V1::Items::FindController < ApplicationController

  def index
    render json: ItemSerializer.new(flitter)
  end

  def show
    render json: ItemSerializer.new(flitter[0])
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id, :created_at, :updated_at, :id)
  end

  def flitter

    item_params.to_h.reduce([]) do |output, (attribute, value)|
      output << Item.where("#{attribute} ilike ?", "%#{value}%")
    end.flatten.uniq
  end
end
