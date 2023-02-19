# frozen_string_literal: true

module Repositories
  # Repositories::HandleJsonResponses
  module HandleJsonResponses
    extend ActiveSupport::Concern

    class_methods do
      private

      def handle_response(response)
        return handle_success(response) if response.success?

        handle_error(response)
      end

      def handle_error(response)
        error_message = "API Repository Error: #{response.status} - #{response.body}"

        Rails.logger.error(error_message)

        raise error_message
      end

      def handle_success(response)
        return {} if response.body.blank?

        JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
