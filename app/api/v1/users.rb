module V1
  class Users < Base
    namespace :users do
      desc "Return JTW token if valid email and password given"
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

      desc "Revoke JTW token"
      delete :logout do
        authenticate!

        if V1::Services::RevokeToken.call(user: current_user)
          status 204
        else
          error!("Revocation failed", 401)
        end
      end

      desc "Return current user"
      get :me do
        authenticate!
        present current_user, with: Entities::User
      end
    end
  end
end
