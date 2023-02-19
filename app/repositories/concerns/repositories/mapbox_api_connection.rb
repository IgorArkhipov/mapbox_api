# frozen_string_literal: true

require 'httpx/adapters/faraday'

module Repositories
  # Repositories::MapboxApiConnection
  module MapboxApiConnection
    extend ActiveSupport::Concern

    ENDPOINT = 'https://api.mapbox.com/geocoding/'

    class_methods do
      private

      def mapbox_api_connection_options
        { url: ENDPOINT, ssl: { verify: false }, request: { timeout: 600, open_timeout: 600 } }
      end

      def mapbox_api_connection
        Faraday.new(mapbox_api_connection_options) do |faraday|
          faraday.adapter :httpx, resolver_options: { cache: false }
        end
      end
    end
  end
end
