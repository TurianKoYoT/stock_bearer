module Api
  module V1
    class StockListService < ApplicationService
      attr_reader :result

      def process
        @result = Stock.all
      end
    end
  end
end
