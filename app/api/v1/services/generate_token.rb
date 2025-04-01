module V1
  module Services
    class GenerateToken < ::Service
      def call(user:)
        Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      end
    end
  end
end
