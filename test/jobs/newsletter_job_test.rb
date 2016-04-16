# frozen_string_literal: true
require 'test_helper'

#
# == NewsletterJobTest
#
class NewsletterJobTest < ActiveJob::TestCase
  setup :initialize_test

  test 'should enqueued job' do
    clear_deliveries_and_queues

    assert_enqueued_jobs 0

    assert_enqueued_with(job: NewsletterJob, args: [@user, @newsletter], queue: 'default') do
      NewsletterJob.perform_later(@user, @newsletter)
    end

    assert_enqueued_jobs 1
  end

  test 'should perform job' do
    clear_deliveries_and_queues

    assert_performed_jobs 0

    perform_enqueued_jobs do
      assert_performed_with(job: NewsletterJob, args: [@user, @newsletter], queue: 'default') do
        NewsletterJob.perform_later(@user, @newsletter)
      end
    end

    assert_performed_jobs 1

    perform_enqueued_jobs do
      assert_performed_with(job: NewsletterJob, args: [@user, @newsletter], queue: 'default') do
        NewsletterJob.perform_later(@user, @newsletter)
      end
    end

    assert_performed_jobs 2
  end

  private

  def initialize_test
    @user = newsletter_users(:newsletter_user_fr)
    @newsletter = newsletters(:one)
  end
end
