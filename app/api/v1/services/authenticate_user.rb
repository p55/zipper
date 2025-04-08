# frozen_string_literal: true

module V1
  module Services
    class AuthenticateUser < ::Service
      def initialize(users_repo: User)
        @users_repo = users_repo
      end


      def call(email:, password:)
        user = @users_repo.find_by(email: email)

        if user && user.valid_password?(password)
          user
        else
          false
        end
      end
    end
  end
end
