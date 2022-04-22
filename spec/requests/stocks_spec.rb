require 'rails_helper'

RSpec.describe 'Stocks', type: :request do
  describe 'GET /index' do
    subject(:make_request) { get '/stocks' }

    let!(:stocks) { create_list(:stock, 2) }

    let(:expected_response) do
      {
        data: [
          {
            type: 'stocks',
            id: stocks.first.id.to_s,
            attributes: {
              name: stocks.first.name
            },
            relationships: {
              bearer: {
                data: {
                  type: 'bearers',
                  id: stocks.first.bearer_id.to_s
                }
              }
            }
          },
          {
            type: 'stocks',
            id: stocks.second.id.to_s,
            attributes: {
              name: stocks.second.name
            },
            relationships: {
              bearer: {
                data: {
                  type: 'bearers',
                  id: stocks.second.bearer_id.to_s
                }
              }
            }
          }
        ],
        included: [
          {
            type: 'bearers',
            id: stocks.first.bearer_id.to_s,
            attributes: {
              name: stocks.first.bearer.name
            }
          },
          {
            type: 'bearers',
            id: stocks.second.bearer_id.to_s,
            attributes: {
              name: stocks.second.bearer.name
            }
          }
        ],
        jsonapi: {
          version: '1.0'
        }
      }.to_json
    end

    it 'returns all stocks with bearer information' do
      make_request
      expect(JSON.parse(response.body)).to eq JSON.parse(expected_response)
    end
  end
end
