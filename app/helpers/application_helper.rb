# frozen_string_literal: true

#
# ApplicationHelper
# ====================
module ApplicationHelper
  #
  # DelayedJob
  # ============
  def delayed_job_enabled?
    candidates = []
    concerned = %w(Video Audio Comment Newsletter Mailing)

    OptionalModule.find_each do |om|
      candidates << om.enabled? if concerned.include?(om.name)
    end
    candidates.include?(true)
  end

  #
  # DateTime
  # ==========
  def current_year
    Time.zone.now.year
  end

  #
  # Site validation
  # ==================
  def google_bing_site_verification
    "#{google_site_verification} #{bing_site_verification}"
  end

  def google_site_verification
    tag(:meta, name: 'google-site-verification', content: Figaro.env.google_site_verification) unless Figaro.env.google_site_verification.blank?
  end

  def bing_site_verification
    tag(:meta, name: 'msvalidate.01', content: Figaro.env.bing_site_verification) unless Figaro.env.bing_site_verification.blank?
  end

  #
  # Maintenance
  # =============
  def maintenance?(req = request)
    @setting.maintenance? && (!req.path.include?('/admin') || !self.class.name.to_s.split('::').first == 'ActiveAdmin')
  end

  #
  # Git
  # ============
  def branch_name
    Rails.env.staging? ? 'BranchName' : `git rev-parse --abbrev-ref HEAD`
  end
end
