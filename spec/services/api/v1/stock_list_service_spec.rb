require 'rails_helper'

RSpec.describe ::Api::V1::StockListService do
  subject(:call) { described_class.call }

  let!(:stocks) { create_list(:stock, 2) }

  before do
    deleted_stock = create(:stock)
    deleted_stock.destroy
  end

  it 'returns non deleted stocks' do
    call
    expect(call.result).to eq stocks
  end
end
