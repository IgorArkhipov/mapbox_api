# frozen_string_literal: true

class MuseumsController < ApplicationController
  def index
    render json: matched_museums, status: :ok
  end

  private

  def match_params
    params.require(:lat)
    params.require(:lng)
    params.permit(%i[lat lng])
  end

  def matched_museums
    current_location = Position.new(
      latitude: match_params[:lat].to_d,
      longitude: match_params[:lng].to_d
    )
    return {} unless current_location.valid?

    data = MuseumRepository.find(
      longitude: current_location.longitude,
      latitude: current_location.latitude
    )

    aggregate_by_postal_code(data[:features])
  end

  # "features": [{
  #   "text": "Macculloch Hall Historical Museum & Gardens",
  #   "context": [{
  #     "id": "postcode.21630700",
  #     "text": "07960"
  #   }]
  # }]
  def aggregate_by_postal_code(features)
    features&.each_with_object({ missing_postcode: [] }) do |feature, acc|
      postcode_context = feature[:context].find { |context| context[:id].start_with?('postcode.') }
      if postcode_context
        postcode = postcode_context[:text]
        acc[postcode] ||= []
        acc[postcode] << feature[:text]
      else
        acc[:missing_postcode] << feature[:text]
      end
    end
  end
end
