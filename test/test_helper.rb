require 'codeclimate-test-reporter'
require 'simplecov'
require 'simplecov-json'

# Start reporters
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  CodeClimate::TestReporter::Formatter
]
SimpleCov.start 'rails'

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

    def model_name
      model_name = self.class.name.demodulize.gsub('ControllerTest', '').underscore.singularize.downcase
      model_name
    end

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

    def assert_crud_actions(obj, url, attributes, check = {})
      unless check.key?(:no_index) && check[:no_index]
        get :index
        assert_redirected_to url
      end

      unless check.key?(:no_show) && check[:no_show]
        get :show, id: obj
        assert_redirected_to url
      end
      get :edit, id: obj
      assert_redirected_to url
      post :create, "#{attributes.to_sym}": {}
      assert_redirected_to url
      patch :update, id: obj, "#{attributes.to_sym}": {}
      assert_redirected_to url

      return if check.key?(:no_delete) && check[:no_delete]
      delete :destroy, id: obj
      assert_redirected_to url
    end

    #
    # == Maintenance
    #
    # Frontend
    def assert_maintenance_frontend(page = :index, id = nil, _code = nil)
      @setting.update_attributes(maintenance: true)
      @locales.each do |locale|
        I18n.with_locale(locale) do
          if id.nil?
            get page, locale: locale.to_s
          else
            get page, id: id, locale: locale.to_s
          end
          assert_maintenance
        end
      end
    end

    def assert_no_maintenance_frontend(page = :index, id = nil, _code = nil)
      @setting.update_attributes(maintenance: true)
      @locales.each do |locale|
        I18n.with_locale(locale) do
          if id.nil?
            get page, locale: locale.to_s
          else
            get page, id: id, locale: locale.to_s
          end
          assert_response :success
          assert_template layout: :application
        end
      end
    end

    # Backend
    def assert_no_maintenance_backend(page = :index, id = nil)
      @setting.update_attributes(maintenance: true)
      if id.nil?
        get page
      else
        get page, id: id
      end
      assert_response :success
    end

    def assert_maintenance_backend(page = :index, id = nil)
      @setting.update_attributes(maintenance: true)
      if id.nil?
        get page
      else
        get page, id: id
      end
    end

    def assert_maintenance
      assert_response 503
      assert_template :maintenance
      assert_template layout: :maintenance
    end

    # Mails deliveries
    def clear_deliveries_and_queues
      clear_enqueued_jobs
      clear_performed_jobs
      ActionMailer::Base.deliveries.clear
      assert_no_enqueued_jobs
      assert ActionMailer::Base.deliveries.empty?
    end
  end # TestCase
end
