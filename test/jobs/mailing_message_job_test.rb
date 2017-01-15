# frozen_string_literal: true
require 'test_helper'

#
# MailingMessageJob test
# ========================
class MailingMessageJobTest < ActiveJob::TestCase
  setup :initialize_test

  test 'should enqueued job' do
    clear_deliveries_and_queues

    assert_enqueued_jobs 0

    assert_enqueued_with(job: MailingMessageJob, args: [@mailing_user, @mailing_message], queue: 'default') do
      MailingMessageJob.perform_later(@mailing_user, @mailing_message)
    end

    assert_enqueued_jobs 1
  end

  test 'should perform job' do
    clear_deliveries_and_queues

    assert_performed_jobs 0

    perform_enqueued_jobs do
      assert_performed_with(job: MailingMessageJob, args: [@mailing_user, @mailing_message], queue: 'default') do
        MailingMessageJob.perform_later(@mailing_user, @mailing_message)
      end
    end

    assert_performed_jobs 1

    perform_enqueued_jobs do
      assert_performed_with(job: MailingMessageJob, args: [@mailing_user, @mailing_message], queue: 'default') do
        MailingMessageJob.perform_later(@mailing_user, @mailing_message)
      end
    end

    assert_performed_jobs 2
  end

  private

  def initialize_test
    @mailing_user = mailing_users(:one)
    @mailing_message = mailing_messages(:one)
  end
end
