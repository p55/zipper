# frozen_string_literal: true

RSpec.shared_examples '400 bad request' do |method_name, endpoint, params: {}, headers: {}|
  it 'returns 400 bad request' do
    send(method_name, endpoint, params: params, headers: headers)
    expect(response.status).to eq 400
  end
end

RSpec.shared_examples '401 unauthorized' do |method_name, endpoint, params: {}, headers: {}|
  it 'returns 401 unauthorized' do
    send(method_name, endpoint, params: params, headers: headers)
    expect(response.status).to eq 401
  end
end
