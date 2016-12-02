# frozen_string_literal: true
require 'test_helper'

#
# ApplicationHelper Test
# ========================
class ApplicationHelperTest < ActionView::TestCase
  setup :initialize_test

  #
  # DelayedJob
  # ============
  test 'should return correct value for delayed_job_enabled?' do
    assert delayed_job_enabled?

    %w(Video Audio Comment Newsletter Mailing).each do |om|
      optional_modules(:"#{om.underscore}").update_attribute(:enabled, false)
    end
    assert_not delayed_job_enabled?
  end

  #
  # DateTime
  # ==========
  test 'should return current year' do
    assert_equal Time.zone.now.year, current_year
  end

  #
  # Maintenance
  # =============
  test 'should return true if maintenance is enabled' do
    @setting.update_attributes(maintenance: true)
    assert maintenance?(@request), 'should be in maintenance'
  end

  test 'should return false if maintenance is disabled' do
    assert_not maintenance?(@request), 'should not be in maintenance'
  end

  #
  # Git
  # =============
  test 'should return correct branch name by environment' do
    Rails.env = 'staging'
    assert_equal 'BranchName', branch_name
    Rails.env = 'development'
    assert_equal `git rev-parse --abbrev-ref HEAD`, branch_name
    Rails.env = 'test'
  end

  #
  # Server
  # ========
  test 'should return correct value for server name' do
    controller.request.env['SERVER_SOFTWARE'] = 'Puma 3.6.2 Sleepy'
    assert_equal 'Puma 3.6.2', server_name
  end

  private

  def initialize_test
    @setting = settings(:one)
  end
end
