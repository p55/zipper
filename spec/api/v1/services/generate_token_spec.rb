require 'rails_helper'

RSpec.describe V1::Services::GenerateToken do
  describe '.call' do
    it 'returns token' do
      user = double(User)
      user_encoder = instance_double(Warden::JWTAuth::UserEncoder)
      fake_token = "fake.jwt.token"

      expect(Warden::JWTAuth::UserEncoder).to receive(:new).and_return(user_encoder)
      expect(user_encoder).to receive(:call).with(user, :user, nil).and_return([ fake_token ])

      expect(described_class.call(user: user)).to eq(fake_token)
    end
  end
end
