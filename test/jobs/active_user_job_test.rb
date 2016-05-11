# frozen_string_literal: true
require 'test_helper'

#
# == ActiveUserJobTest
#
class ActiveUserJobTest < ActiveJob::TestCase
  setup :initialize_test

  test 'should enqueued job' do
    clear_deliveries_and_queues
    assert_enqueued_jobs 0

    assert_enqueued_with(job: ActiveUserJob, args: [@user], queue: 'default') do
      ActiveUserJob.perform_later(@user)
    end

    assert_enqueued_jobs 1
  end

  test 'should perform job' do
    clear_deliveries_and_queues
    assert_performed_jobs 0

    perform_enqueued_jobs do
      assert_performed_with(job: ActiveUserJob, args: [@user], queue: 'default') do
        ActiveUserJob.perform_later(@user)
      end
    end

    assert_performed_jobs 1
  end

  private

  def initialize_test
    @user = users(:bart)
  end
end
