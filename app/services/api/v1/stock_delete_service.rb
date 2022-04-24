module Api
  module V1
    class StockDeleteService < Api::ApplicationService
      attr_reader :result

      params do
        required(:id).filled(:integer)
      end

      def process
        Stock.destroy(id)
      end
    end
  end
end
