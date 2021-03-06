require 'rails_helper'

RSpec.describe 'Stocks', type: :request do
  def json_headers
    { 'Content-Type': 'application/vnd.api+json', 'Accept': 'application/vnd.api+json' }
  end

  shared_examples 'responds with status' do |status|
    it "returns #{status} status" do
      make_request
      expect(response).to have_http_status status
    end
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

    it_behaves_like 'responds with status', :ok
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

    it_behaves_like 'responds with status', :created

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

      let(:expected_response) do
        {
          errors: [
            {
              source: { pointer: '/data/attributes/bearer_id' },
              title: 'is missing'
            }
          ],
          jsonapi: {
            version: '1.0'
          }
        }.to_json
      end

      it 'returns errors' do
        make_request
        expect(JSON.parse(response.body)).to eq JSON.parse(expected_response)
      end

      it_behaves_like 'responds with status', :not_found
    end

    context 'with bearer not existing' do
      let(:params) do
        {
          data: {
            type: 'stocks',
            attributes: {
              name: 'Stock api name',
              bearer_id: 999_999.to_s
            }
          }
        }
      end

      let(:expected_response) do
        {
          errors: [
            {
              source: { pointer: '/data/attributes/bearer' },
              title: 'must exist'
            }
          ],
          jsonapi: {
            version: '1.0'
          }
        }.to_json
      end

      it 'returns errors' do
        make_request
        expect(JSON.parse(response.body)).to eq JSON.parse(expected_response)
      end

      it_behaves_like 'responds with status', :not_found
    end
  end

  describe 'PATCH /stocks/{:id}' do
    subject(:make_request) { patch "/stocks/#{stock.id}", params: params.to_json, headers: json_headers }

    let!(:stock) { create(:stock) }
    let!(:initial_bearer_id) { stock.bearer_id }

    let(:params) do
      {
        data: {
          type: 'stocks',
          id: stock.id.to_s,
          attributes: {
            name: 'Stock api name'
          }
        }
      }
    end

    it 'update stock' do
      make_request
      expect(Stock.last).to have_attributes(name: 'Stock api name')
    end

    it_behaves_like 'responds with status', :no_content

    context 'when passed bearer_id' do
      let(:params) do
        {
          data: {
            type: 'stocks',
            id: stock.id.to_s,
            attributes: {
              name: 'Stock api name',
              bearer_id: 999_999.to_s
            }
          }
        }
      end

      it 'updates record without changing bearer_id' do
        make_request
        expect(Stock.last).to have_attributes(name: 'Stock api name', bearer_id: initial_bearer_id)
      end

      it_behaves_like 'responds with status', :no_content
    end

    context 'when id is not passed in data' do
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

      let(:expected_response) do
        {
          errors: [
            {
              source: { pointer: '/data/attributes/id' },
              title: 'must be filled'
            }
          ],
          jsonapi: {
            version: '1.0'
          }
        }.to_json
      end

      it 'returns errors' do
        make_request
        expect(JSON.parse(response.body)).to eq JSON.parse(expected_response)
      end

      it_behaves_like 'responds with status', :not_found
    end
  end

  describe 'DELETE /stocks/{:id}' do
    subject(:make_request) { delete "/stocks/#{stock.id}", headers: json_headers }

    let!(:stock) { create(:stock) }

    it 'soft_deletes stock' do
      make_request
      expect(stock.reload).to be_deleted
    end

    it_behaves_like 'responds with status', :no_content
  end
end
