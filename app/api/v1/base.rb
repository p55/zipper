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
    mount V1::ZipArchives

    add_swagger_documentation(
      mount_path: "/docs",
      info: {
        title: "Zipper API",
        description: "API for user logging and creating zip archives"
      },
      api_version: "v1",
      hide_documentation_path: true,
      security_definitions: {
        Bearer: {
          type: "apiKey",
          name: "Authorization",
          in: "header"
        }
      },
    )
  end
end
