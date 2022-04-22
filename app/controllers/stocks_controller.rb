class StocksController < ApplicationController
  def index
    render jsonapi: Api::V1::StockListService.call.result, include: [:bearer]
  end
end
