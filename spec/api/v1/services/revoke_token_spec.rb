# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Services::RevokeToken do
  describe '.call' do
    it 'revokes token for given user' do
      user = double(User)

      expect(User).to receive(:revoke_jwt).with({}, user).and_return(true)
      expect(described_class.call(user: user)).to eq(true)
    end
  end
end
