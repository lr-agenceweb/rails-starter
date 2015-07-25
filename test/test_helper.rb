require 'simplecov'
require 'codeclimate-test-reporter'
SimpleCov.start 'rails' do
  formatter SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
end
# CodeClimate::TestReporter.start

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
    include ActiveJob::TestHelper

    ActiveRecord::Migration.check_pending!
    Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def disable_optional_module(user, optional_module, name)
      old_controller = @controller
      sign_in user
      @controller = Admin::OptionalModulesController.new
      patch :update, id: optional_module, optional_module: { enabled: '0' }
      assert name, assigns(:optional_module).name
      assert_not assigns(:optional_module).enabled, 'Module should be disabled'
      assert_redirected_to admin_optional_module_path(assigns(:optional_module))
      sign_out user
    ensure
      @controller = old_controller
    end

    # Attachment upload
    def assert_processed(filename, style, model_instance_property)
      path = model_instance_property.path(style)
      assert_match Regexp.new(Regexp.escape(filename) + '$'), path
      assert File.exist?(path), "#{style} not processed"
    end

    def assert_not_processed(filename, style, model_instance_property)
      path = model_instance_property.path(style)
      assert_match Regexp.new(Regexp.escape(filename) + '$'), path
      assert_not File.exist?(model_instance_property.path(style)), "#{style} unduly processed"
    end
  end
end
