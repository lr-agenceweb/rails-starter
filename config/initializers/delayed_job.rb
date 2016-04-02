# frozen_string_literal: true
Delayed::Worker.lifecycle.before(:enqueue) do |job|
  # If Locale is not set
  if job.locale.nil? || job.locale.empty? && I18n.locale.to_s != I18n.default_locale.to_s
    job.locale = I18n.locale
  end
end

Delayed::Worker.lifecycle.around(:invoke_job) do |job, &block|
  saved_locale = I18n.locale

  begin
    # Set locale from job or if not set use the default
    I18n.locale = if job.locale.nil?
                    I18n.default_locale
                  else
                    job.locale
                  end

    # now really perform the job
    block.call(job)

  ensure
    # Clean state from before setting locale
    I18n.locale = saved_locale
  end
end
