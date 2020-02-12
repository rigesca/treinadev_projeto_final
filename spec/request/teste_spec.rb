require 'rails_helper'

RSpec.describe 'Teste de API para projeto', type: :request do
  it 'teste' do
    get '/api/v1/client/15ad851a1/payment_simulation'

    json = JSON.parse(response.body, symbolize_names: true)
  
    expect(response).to have_http_status(:ok)

    expect(json[:payment_method]).to eq('boleto')
    expect(json[:value]).to eq(1000)
    expect(json[:discount]).to eq(900)
    expect(json[:tax_total]).to eq(1010)
    expect(json[:installments]).to eq(1)
  end
end
