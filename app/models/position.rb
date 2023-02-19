# frozen_string_literal: true

class Position
  include ActiveModel::Model

  attr_accessor :latitude, :longitude

  validates :latitude, presence: true,
                       numericality: { greater_than_or_equal_to: -90.0, less_than_or_equal_to: 90.0 }
  validates :longitude, presence: true,
                        numericality: { greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0 }
end
