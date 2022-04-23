require 'rails_helper'
require 'errors_set'

RSpec.describe ErrorsSet do
  subject(:set) { described_class.new }

  describe '#add!' do
    let(:key) { :error_key }

    let(:value_1) { 'error_1' }
    let(:value_2) { 'error_2' }

    let(:expected_value) { { 'error_key' => %w[error_1 error_2] } }

    it 'adds key to error by key' do
      set.add!(key, value_1)
      set.add!(key, value_2)

      expect(set.errors).to eq expected_value
    end
  end

  describe '#merge!' do
    before { set.add!(:error_key, 'error_1') }

    let(:set_to_merge) { { error_key: ['error_2'], another_key: ['error_3'] } }

    let(:expected_value) { { 'error_key' => %w[error_1 error_2], 'another_key' => ['error_3'] } }

    it 'merges error_set and passed hash' do
      set.merge!(set_to_merge)

      expect(set.errors).to eq expected_value
    end
  end
end
