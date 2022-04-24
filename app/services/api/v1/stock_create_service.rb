module Api
  module V1
    class StockCreateService < Api::ApplicationService
      attr_reader :result

      params do
        required(:name).filled(:string)
        required(:bearer_id).filled(:string)
      end

      def process
        stock = Stock.new(
          name: name,
          bearer_id: bearer_id
        )

        if stock.save
          @result = stock
        else
          errors.merge!(stock.errors)
        end
      end
    end
  end
end
