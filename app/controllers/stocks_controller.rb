class StocksController < ApplicationController
  deserializable_resource :stock, class: DeserializableStock, only: [:create]

  def index
    render jsonapi: Api::V1::StockListService.call.result, include: [:bearer]
  end

  def create
    service = Api::V1::StockCreateService.call(**create_params)

    if service.success?
      render jsonapi: service.result, include: [:bearer]
    else
      render jsonapi_errors: [{ title: 'Task already has completed submission.' }]
    end
  end

  private

  def create_params
    params.require(:stock).permit(:name, :bearer_id)
  end
end
