require 'rails_helper'

RSpec.describe 'Stocks', type: :request do
  def json_headers
    { 'Content-Type': 'application/vnd.api+json', 'Accept': 'application/vnd.api+json' }
  end

  describe 'GET /stocks' do
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

  describe 'POST /stocks' do
    subject(:make_request) { post '/stocks', params: params.to_json, headers: json_headers }

    let(:bearer) { create(:bearer) }

    let(:params) do
      {
        data: {
          type: 'stocks',
          attributes: {
            name: 'Stock api name',
            bearer_id: bearer.id.to_s
          }
        }
      }
    end

    let(:expected_response) do
      {
        data:
          {
            type: 'stocks',
            id: Stock.last.id.to_s,
            attributes: {
              name: Stock.last.name
            },
            relationships: {
              bearer: {
                data: {
                  type: 'bearers',
                  id: Stock.last.bearer_id.to_s
                }
              }
            }
          },
        included: [
          {
            type: 'bearers',
            id: Stock.last.bearer_id.to_s,
            attributes: {
              name: Stock.last.bearer.name
            }
          }
        ],
        jsonapi: {
          version: '1.0'
        }
      }.to_json
    end

    it 'creates stock with specified bearer' do
      make_request
      expect(Stock.last).to have_attributes(bearer_id: bearer.id, name: 'Stock api name')
    end

    it 'returns created object specification' do
      make_request
      expect(JSON.parse(response.body)).to eq JSON.parse(expected_response)
    end

    context 'with no bearer passed' do
      let(:params) do
        {
          data: {
            type: 'stocks',
            attributes: {
              name: 'Stock api name'
            }
          }
        }
      end

      let(:expected_response) { {}.to_json }

      it 'returns errors' do
        make_request
        expect(JSON.parse(response.body)).to eq JSON.parse(expected_response)
      end
    end
  end
end