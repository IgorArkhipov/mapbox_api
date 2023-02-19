# frozen_string_literal: true

require 'test_helper'

class MuseumsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @controller = MuseumsController.new
  end

  test 'should retrieve museums for valid location' do
    valid_params = { lat: '52.494857', lng: '13.437641' }
    result = { missing_postcode: [] }
    MuseumsController.any_instance.expects(:matched_museums).returns(result)

    get museums_url, params: valid_params

    assert_response :success
    assert_equal 1, JSON.parse(response.body).size
  end

  test 'should retrieve empty list of museums for invalid location' do
    invalid_params = { lat: 'invalid', lng: '13.437641' }
    result = {}
    MuseumsController.any_instance.expects(:matched_museums).returns(result)

    get museums_url, params: invalid_params

    assert_response :success
    assert_equal 0, JSON.parse(response.body).size
  end

  test 'matched_museums should return empty list of museums when params are invalid' do
    matched_params = ActionController::Parameters.new(lng: 4.0, lat: 'invalid')

    @controller.expects(:match_params).returns(matched_params).twice
    MuseumRepository.expects(:find).never

    assert_empty @controller.send(:matched_museums)
  end

  test 'matched_museums should call repository and return predefined list' do
    matched_params = ActionController::Parameters.new(lng: 4.0, lat: 5.0)
    collection = { features: {} }
    result = { missing_postcode: [] }

    @controller.expects(:match_params).returns(matched_params).twice
    MuseumRepository.expects(:find)
                    .with(longitude: matched_params[:lng],
                          latitude: matched_params[:lat])
                    .returns(collection)
    @controller.expects(:aggregate_by_postal_code).with(collection[:features])
               .returns(result)

    assert_equal(result, @controller.send(:matched_museums))
  end

  test 'aggregate_by_postal_code should correctly align found museums to their postal code' do
    features = JSON.parse(
      File.read('test/fixtures/files/museum_data.json'), symbolize_names: true
    )[:features]
    result = { missing_postcode: [],
               '10969': ['Jüdisches Museum Berlin', 'Berlinische Galerie'],
               '10997': ['R.M.C.M Ramones Museum'],
               '10963': ['Topographie des Terrors', 'Martin-Gropius-Bau'],
               '10178': ['DDR Museum', 'Neues Museum', 'Alte Nationalgalerie'],
               '10117': ['Zeughaus'], '10999': ['FHXB Friedrichshain Kreuzberg Museum'] }

    assert_equal result, @controller.send(:aggregate_by_postal_code, features)
  end

  test 'aggregate_by_postal_code should return empty list when no features are present' do
    assert_empty(@controller.send(:aggregate_by_postal_code, nil))
  end
end
