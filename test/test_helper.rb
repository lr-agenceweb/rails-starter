ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'

#
# == ActiveSupport namespace
#
module ActiveSupport
  #
  # == TestCase class
  #
  class TestCase
    ActiveRecord::Migration.check_pending!

    Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
