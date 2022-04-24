module Api
  module V1
    class StockUpdateService < Api::ApplicationService
      attr_reader :result

      params do
        required(:id).filled(:integer)
        optional(:name).maybe(:string)
      end

      def process
        stock = Stock.find(id)

        if stock.update(name: name)
          @result = stock
        else
          errors.merge!(stock.errors)
        end
      end
    end
  end
end
