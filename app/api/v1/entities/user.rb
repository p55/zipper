module V1
  module Entities
    class User < Grape::Entity
      expose :id, :email, :created_at
    end
  end
end
