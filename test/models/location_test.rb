# frozen_string_literal: true
require 'test_helper'

#
# Location Model test
# =====================
class LocationTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # Shoulda
  # =========
  should belong_to(:locationable)

  should validate_presence_of(:address)
  should validate_presence_of(:city)
  should validate_presence_of(:postcode)

  should validate_numericality_of(:postcode)

  #
  # Validation rules
  # ==================
  test 'should be valid if all good' do
    location = Location.new default_attrs
    assert location.valid?
    assert_empty location.errors.keys
    assert_empty location.errors.messages
  end

  test 'should not be valid if address is empty' do
    attrs = default_attrs
    attrs[:address] = ''

    location = Location.new attrs
    assert_not location.valid?
    assert_equal [:address], location.errors.keys
    assert_equal [I18n.t('address.blank', scope: @scope)], location.errors.messages[:address]
  end

  test 'should not be valid if city is empty' do
    attrs = default_attrs
    attrs[:city] = ''

    location = Location.new attrs
    assert_not location.valid?
    assert_equal [:city], location.errors.keys
    assert_equal [I18n.t('city.blank', scope: @scope)], location.errors.messages[:city]
  end

  test 'should not be valid if postcode is empty' do
    attrs = default_attrs
    attrs[:postcode] = ''

    location = Location.new attrs
    assert_not location.valid?
    assert_equal [:postcode], location.errors.keys
    assert_equal [I18n.t('postcode.blank', scope: @scope), I18n.t('postcode.not_a_number', scope: @scope)], location.errors.messages[:postcode]
  end

  test 'should not be valid if postcode is not integer' do
    attrs = default_attrs
    attrs[:postcode] = 'bad value'

    location = Location.new attrs
    assert_not location.valid?
    assert_equal [:postcode], location.errors.keys
    assert_equal [I18n.t('postcode.not_a_number', scope: @scope)], location.errors.messages[:postcode]
  end

  #
  # Boolean
  # =========
  test 'should return true as boolean for latlon?' do
    assert @location.latlon?
  end

  test 'should return true as boolean for city?' do
    assert @location.city?
  end

  test 'should return true as boolean for postcode?' do
    assert @location.city?
  end

  test 'should return false as boolean for latlon?' do
    location = LocationDecorator.new(@location_three)
    assert_not location.latlon?
  end

  private

  def initialize_test
    @setting = settings(:one)
    @scope = 'activerecord.errors.models.location.attributes'

    @location = locations(:one)
    @location_three = locations(:three)
  end

  def default_attrs
    {
      locationable_id: @setting.id,
      locationable_type: 'Setting',
      address: 'Owl street',
      city: 'Brest',
      postcode: 29_000
    }
  end
end
