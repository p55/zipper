# frozen_string_literal: true

module ApiHelpers
  def parsed_response(response, symbolize_names: true)
    JSON.parse(response.body, symbolize_names:)
  end
end


RSpec.configure do |config|
  config.include ApiHelpers, type: :request
end
