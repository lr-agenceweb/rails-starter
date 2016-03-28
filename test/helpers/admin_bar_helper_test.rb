# frozen_string_literal: true
require 'test_helper'

#
# == AdminBarHelper Test
#
class AdminBarHelperTest < ActionView::TestCase
  setup :initialize_test

  test 'should return correct greeting value if morning' do
    Timecop.freeze(Time.zone.local(2016, 2, 6, 10, 50, 0)) do
      @locales.each do |locale|
        I18n.with_locale(locale) do
          assert_equal 'Bonjour', morning_or_evening if locale == :fr
          assert_equal 'Good morning', morning_or_evening if locale == :en
        end
      end
    end
  end

  test 'should return correct greeting value if afternoon' do
    Timecop.freeze(Time.zone.local(2016, 2, 6, 14, 50, 0)) do
      @locales.each do |locale|
        I18n.with_locale(locale) do
          assert_equal 'Bonjour', morning_or_evening if locale == :fr
          assert_equal 'Good afternoon', morning_or_evening if locale == :en
        end
      end
    end
  end

  test 'should return correct greeting value if evening' do
    Timecop.freeze(Time.zone.local(2016, 2, 6, 19, 50, 0)) do
      @locales.each do |locale|
        I18n.with_locale(locale) do
          assert_equal 'Bonsoir', morning_or_evening if locale == :fr
          assert_equal 'Good evening', morning_or_evening if locale == :en
        end
      end
    end
  end

  def initialize_test
    @locales = I18n.available_locales
  end
end
