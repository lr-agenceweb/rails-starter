# frozen_string_literal: true
require 'test_helper'

#
# WelcomeNewsletterJob Test
# ===========================
class WelcomeNewsletterJobTest < ActiveJob::TestCase
  setup :initialize_test

  test 'should enqueued job' do
    clear_deliveries_and_queues

    assert_enqueued_jobs 0

    assert_enqueued_with(job: WelcomeNewsletterJob, args: [@user, @newsletter_setting], queue: 'default') do
      WelcomeNewsletterJob.perform_later(@user, @newsletter_setting)
    end

    assert_enqueued_jobs 1
  end

  test 'should perform job' do
    clear_deliveries_and_queues

    assert_performed_jobs 0

    perform_enqueued_jobs do
      assert_performed_with(job: WelcomeNewsletterJob, args: [@user, @newsletter_setting], queue: 'default') do
        WelcomeNewsletterJob.perform_later(@user, @newsletter_setting)
      end
    end

    assert_performed_jobs 1

    perform_enqueued_jobs do
      assert_performed_with(job: WelcomeNewsletterJob, args: [@user, @newsletter_setting], queue: 'default') do
        WelcomeNewsletterJob.perform_later(@user, @newsletter_setting)
      end
    end

    assert_performed_jobs 2
  end

  private

  def initialize_test
    @user = newsletter_users(:newsletter_user_fr)
    @newsletter_setting = newsletter_settings(:one)
  end
end
