require 'rails_helper'

RSpec.describe Bearer, type: :model do
  context 'when name is blank' do
    it 'raises validation error' do
      expect { create(:bearer, name: '') }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'when bearer with same name exists' do
    let!(:existing_bearer) { create(:bearer) }

    it 'raises not unique error' do
      expect { create(:bearer, name: existing_bearer.name) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
