# frozen_string_literal: true

module V1
  module Services
    class FindUser < ::Service
      def initialize(users_repo: User)
        @users_repo = users_repo
      end


      def call(token:)
        decoded_payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first

        @users_repo.find_by(
          id: decoded_payload["sub"],
          jti: decoded_payload["jti"]
        )
      end
    end
  end
end
