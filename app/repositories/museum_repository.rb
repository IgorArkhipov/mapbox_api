# frozen_string_literal: true

# MuseumRepository
class MuseumRepository
  include Repositories::MapboxApiConnection
  include Repositories::HandleJsonResponses

  ACCESS_TOKEN = Rails.application.credentials[:mapbox_access_token]
  RESULTS_COUNT = 10

  class << self
    # https://docs.mapbox.com/api/search/#mapboxplaces
    # options: type=poi&proximity=<longitude>,<latitude>&access_token=...
    def find(longitude:, latitude:)
      response = mapbox_api_connection.get(
        'v5/mapbox.places/museum.json',
        { type: 'poi', proximity: "#{longitude},#{latitude}",
          limit: RESULTS_COUNT, access_token: ACCESS_TOKEN }
      )

      handle_response(response)
    rescue StandardError
      {}
    end
  end
end
