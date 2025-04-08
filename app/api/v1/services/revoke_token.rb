# frozen_string_literal: true

module V1
  module Services
    class RevokeToken < ::Service
      def initialize(users_repo: User)
        @users_repo = users_repo
      end

      def call(user:)
        @users_repo.revoke_jwt({}, user)
      end
    end
  end
end
