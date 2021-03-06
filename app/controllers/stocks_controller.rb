class StocksController < ApplicationController
  deserializable_resource :stock, class: DeserializableStock, only: [:create, :update]

  def index
    render jsonapi: Api::V1::StockListService.call.result, include: [:bearer]
  end

  def create
    service = Api::V1::StockCreateService.call(**create_params)

    if service.success?
      render jsonapi: service.result, include: [:bearer], status: :created
    else
      render jsonapi_errors: service.errors.to_json, status: :not_found
    end
  end

  def update
    service = Api::V1::StockUpdateService.call(id: update_id, **update_params)

    if service.success?
      render status: :no_content
    else
      render jsonapi_errors: service.errors.to_json, status: :not_found
    end
  end

  def destroy
    service = Api::V1::StockDeleteService.call(id: params[:id])

    if service.success?
      render status: :no_content
    else
      render jsonapi_errors: service.errors.to_json, status: :not_found
    end
  end

  private

  def create_params
    params.require(:stock).permit(:name, :bearer_id)
  end

  def update_id
    params.require(:_jsonapi).require(:data)[:id]
  end

  def update_params
    params.require(:stock).permit(:name)
  end
end
