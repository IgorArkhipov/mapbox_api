# frozen_string_literal: true

require 'test_helper'

class PositionTest < ActiveSupport::TestCase
  test 'should have longitude in strong boundaries' do
    assert_not Position.new(latitude: 0, longitude: -181).valid?
    assert_not Position.new(latitude: 0, longitude: 'test').valid?
    assert_predicate Position.new(latitude: 0, longitude: 180), :valid?
  end

  test 'should have latitude in strong boundaries' do
    assert_not Position.new(latitude: 91, longitude: 0).valid?
    assert_not Position.new(latitude: 'test', longitude: 0).valid?
    assert_predicate Position.new(latitude: 90, longitude: 0), :valid?
  end
end
