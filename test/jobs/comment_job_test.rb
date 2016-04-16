# frozen_string_literal: true
require 'test_helper'

#
# == CommentJobTest
#
class CommentJobTest < ActiveJob::TestCase
  setup :initialize_test

  test 'should enqueued job' do
    clear_deliveries_and_queues

    assert_enqueued_jobs 0

    assert_enqueued_with(job: CommentJob, args: [@comment], queue: 'default') do
      CommentJob.perform_later(@comment)
    end

    assert_enqueued_jobs 1
  end

  test 'should perform job' do
    clear_deliveries_and_queues

    assert_performed_jobs 0

    perform_enqueued_jobs do
      assert_performed_with(job: CommentJob, args: [@comment], queue: 'default') do
        CommentJob.perform_later(@comment)
      end
    end

    assert_performed_jobs 1

    perform_enqueued_jobs do
      assert_performed_with(job: CommentJob, args: [@comment], queue: 'default') do
        CommentJob.perform_later(@comment)
      end
    end

    assert_performed_jobs 2
  end

  private

  def initialize_test
    @comment = comments(:one)
  end
end
