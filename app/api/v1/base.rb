module V1
  class Base < Grape::API
    version "v1", using: :path
    format :json
    prefix :api

    helpers do
      def current_user
        @current_user ||= V1::Services::FindUser.call(token: headers["authorization"].split(" ").last)
      rescue NoMethodError, JWT::VerificationError, JWT::DecodeError
        false
      end

      def authenticate!
        error!("401 Unauthorized", 401) unless current_user
      end
    end

    mount V1::Users
  end
end
