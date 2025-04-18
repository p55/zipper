# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User authorization', type: :request do
  describe 'POST /api/v1/users/login' do
    let(:user) { create(:user, password: 'password') }

    context 'no email is provided' do
      it_behaves_like(
        '400 bad request',
        'post',
        '/api/v1/users/login',
        params: { password: 'foo123' }
      )
    end

    context 'no password is provided' do
      it_behaves_like(
        '400 bad request',
        'post',
        '/api/v1/users/login',
        params: { email: 'foo@example.com' }
      )
    end

    context 'invalid email is provided' do
      it 'returns 401 unauthorized' do
        post '/api/v1/users/login',
          params: { email: 'invalid@example.com', password: user.password },
          headers: { 'Accept' => 'application/json' }
        expect(response.status).to eq(401)
      end
    end

    context 'invalid password is provided' do
      it 'returns 401 unauthorized' do
        post '/api/v1/users/login',
          params: { email: user.email, password: 'invalid' },
          headers: { 'Accept' => 'application/json' }
        expect(response.status).to eq(401)
      end
    end

    context 'valid email and password are provided' do
      it 'returns token' do
        post '/api/v1/users/login',
          params: { email: user.email, password: user.password },
          headers: { 'Accept' => 'application/json' }
        expect(response.status).to eq(200)

        parsed_response = parsed_response(response)
        expect(parsed_response).to have_key(:token)
        expect(parsed_response[:token]).to_not be_empty
      end
    end
  end

  describe 'DELETE /api/v1/users/logout' do
    context 'no token is provided' do
      it_behaves_like '401 unauthorized', 'get', '/api/v1/users/me'
    end

    context 'invalid token is provided' do
      it_behaves_like(
        '401 unauthorized',
        'get',
        '/api/v1/users/me',
        headers: { 'Authorization' => "Bearer #{SecureRandom.hex}" }
      )
    end

    context 'valid token is provided' do
      it 'revokes user jti' do
        user = create(:user)
        token = V1::Services::GenerateToken.call(user: user)
        headers = {
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }

        expect {
          delete '/api/v1/users/logout', headers: headers
        }.to(change { user.reload.jti })

        expect(response.status).to eq(204)
        expect(response.body).to be_empty
      end
    end
  end

  describe 'GET /api/v1/users/me' do
    context 'no token is provided' do
      it_behaves_like '401 unauthorized', 'get', '/api/v1/users/me'
    end

    context 'invalid token is provided' do
      it_behaves_like(
        '401 unauthorized',
        'get',
        '/api/v1/users/me',
        headers: { 'Authorization' => "Bearer #{SecureRandom.hex}" }
      )
    end

    context 'valid token is provided' do
      it 'returns user json data' do
        user = create(:user)
        token = V1::Services::GenerateToken.call(user: user)
        headers = {
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }

        get '/api/v1/users/me', headers: headers

        expect(response).to be_successful
        expect(response.content_type).to eq('application/json')
        expect(response.body).to eq(V1::Entities::User.new(user).to_json)
      end
    end
  end
end
