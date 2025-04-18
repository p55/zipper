# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Services::AuthenticateUser do
  describe '.call' do
    let(:user) { build(:user) }
    let(:password) { 'fake_password' }

    context 'user is not found' do
      it 'returns false' do
        expect(User).to receive(:find_by).with(email: user.email).and_return(nil)

        expect(
          described_class.call(email: user.email, password: password)
          ).to eq(false)
      end
    end

    context 'user is found' do
      before { expect(User).to receive(:find_by).with(email: user.email).and_return(user) }

      context 'user provided incorrect password' do
        it 'returns false' do
          expect(user).to receive(:valid_password?).with(password).and_return(false)

          expect(
            described_class.call(email: user.email, password: password)
            ).to eq(false)
        end
      end

      context 'user provided correct password' do
        it 'returns user' do
          expect(user).to receive(:valid_password?).with(password).and_return(true)

          expect(
            described_class.call(email: user.email, password: password)
            ).to eq(user)
        end
      end
    end
  end
end
