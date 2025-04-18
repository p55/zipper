# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Entities::User, type: :entity do
  describe '.represent' do
    it 'exposes user attributes' do
      user = create(:user)

      expect(
        described_class.represent(user).as_json
      ).to eq({
        id: user.id,
        email: user.email,
        created_at: user.created_at
      })
    end
  end
end
