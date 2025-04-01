module ApiHelpers
  def parsed_response(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end


RSpec.configure do |config|
  config.include ApiHelpers, type: :request
end
