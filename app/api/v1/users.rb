# frozen_string_literal: true

module V1
  class Users < Base
    namespace :users do
      desc "Return JWT token if valid email and password given" do
        detail "Authenticate user and return access token"
        success code: 200, message: "Token generated", examples: {
          "application/json" => {
            token: "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.n8N9_OmjfG3Y9YmKqKjA3EjOyoY5Rmzr2bw"
          }
        }
        failure [
          { code: 401, message: "Unauthorized" }
        ]
        tags [ "Authentication" ]
      end
      params do
        requires :email, type: String, desc: "User email"
        requires :password, type: String, desc: "User password"
      end
      post :login do
        user = V1::Services::AuthenticateUser.call(email: params[:email], password: params[:password])

        if user
          status 200
          { token: V1::Services::GenerateToken.call(user: user) }
        else
          error!("Unauthorized", 401)
        end
      end

      desc "Revoke JWT token" do
        detail "Invalidate user token"
        success code: 204, message: "Token revoked"
        failure [
          { code: 401, message: "Unauthorized" }
        ]
        tags [ "Authentication" ]
        security [ { Bearer: [] } ]
      end
      delete :logout do
        authenticate!

        if V1::Services::RevokeToken.call(user: current_user)
          status 204
        else
          error!("Revocation failed", 401)
        end
      end

      desc "Return current user" do
        detail "Return user details for authenticated user"
        success code: 200, message: "Current user returned", examples: {
          "application/json" => {
            id: 1,
            email: "user@example.com",
            created_at: "2024-04-01T12:00:00Z",
            updated_at: "2024-04-01T12:00:00Z"
          }
        }
        failure [
          { code: 401, message: "Unauthorized" }
        ]
        tags [ "User" ]
        security [ { Bearer: [] } ]
      end
      get :me do
        authenticate!

        present current_user, with: Entities::User
      end
    end
  end
end
