require 'rails_helper'

RSpec.describe Stock, type: :model do
  context 'when name is blank' do
    it 'raises validation error' do
      expect { create(:stock, name: '') }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'when stock with same name exists' do
    let!(:existing_stock) { create(:stock) }

    it 'raises not unique error' do
      expect { create(:stock, name: existing_stock.name) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  context 'when stock is created without bearer' do
    it 'raises validation error' do
      expect { create(:stock, bearer: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
