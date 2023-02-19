# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock'

class MuseumRepositoryTest < ActiveSupport::TestCase
  setup do
    @location = { latitude: '52.494857', longitude: '13.437641' }
    @response = { 'test' => 'response' }
    @mapbox_api_connection = MiniTest::Mock.new
    @mapbox_api_connection.expect(
      :get, @response,
      ['v5/mapbox.places/museum.json',
       { type: 'poi', proximity: "#{@location[:longitude]},#{@location[:latitude]}",
         limit: MuseumRepository::RESULTS_COUNT, access_token: MuseumRepository::ACCESS_TOKEN }]
    )
    MuseumRepository.expects(:mapbox_api_connection).returns(@mapbox_api_connection)
  end

  test '.find with correct server response' do
    handled_response = { 'test' => 'handled_response' }

    MuseumRepository.expects(:handle_response)
                    .with(@response)
                    .returns(handled_response)

    assert_equal(
      handled_response,
      MuseumRepository.send(:find, longitude: @location[:longitude], latitude: @location[:latitude])
    )
  end

  test '.find with incorrect server response' do
    handled_response = {}

    MuseumRepository.expects(:handle_response)
                    .with(@response)
                    .raises

    assert_equal(
      handled_response,
      MuseumRepository.send(:find, longitude: @location[:longitude], latitude: @location[:latitude])
    )
  end
end
