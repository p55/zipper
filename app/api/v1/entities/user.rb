module V1
  module Entities
    class User < Grape::Entity
      expose :id, documentation: { type: "Integer", example: 1234 }
      expose :email,  documentation: { type: "String", example: "test@test.com" }
      expose :created_at, documentation: { type: "DateTime", example: "2025-04-09T12:00:00Z" }
    end
  end
end
