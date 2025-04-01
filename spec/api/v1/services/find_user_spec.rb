require 'rails_helper'

RSpec.describe V1::Services::FindUser do
  describe '.call' do
    let(:token) { 'fake.jwt.token' }
    let(:decoded_payload) { { "sub" => 1, "jti" => "fake_jti" } }
    let(:secret_key) { "fake-secret-key" }

    before do
      expect(Rails.application.credentials).to receive(:devise_jwt_secret_key!)
        .and_return(secret_key)
    end

    context 'token can not be decoded' do
      it 'raises an error' do
        expect(JWT).to receive(:decode).with(token, secret_key).and_raise(JWT::DecodeError)

        expect { described_class.call(token: token) }.to raise_error(JWT::DecodeError)
      end
    end

    context 'token is correctly decoded' do
      before do
        expect(JWT).to receive(:decode).with(token, secret_key).and_return([ decoded_payload ])
      end

      context 'user is not found' do
        it 'returns false' do
          expect(User).to receive(:find_by)
            .with(id: decoded_payload["sub"], jti: decoded_payload["jti"])
            .and_return(nil)

          expect(described_class.call(token: token)).to eq(nil)
        end
      end

      context 'user is found' do
        it 'returns user' do
          user = double(User, id: decoded_payload['sub'], jti: decoded_payload['jti'])

          expect(User).to receive(:find_by)
            .with(id: decoded_payload["sub"], jti: decoded_payload["jti"])
            .and_return(user)

          expect(described_class.call(token: token)).to eq(user)
        end
      end
    end
  end
end
