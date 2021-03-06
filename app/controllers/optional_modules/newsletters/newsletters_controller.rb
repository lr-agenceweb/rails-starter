# frozen_string_literal: true

#
# NewslettersController
# =======================
class NewslettersController < ApplicationController
  include NewsletterUserable
  include Newsletterable

  layout 'mailers/newsletter'

  # Callbacks
  before_action :not_found,
                unless: proc { @newsletter_module.enabled? }
  before_action :set_vars,
                only: [:preview_in_browser, :welcome_user]
  before_action :set_newsletter_setting

  # Preview Welcome email in browser
  def welcome_user
    raise ActionController::RoutingError, 'Not Found' unless all_conditions_respected?
    welcome_newsletter = NewsletterSetting.first
    @content = welcome_newsletter.try(:content_subscriber)
    @newsletter_user.name = @newsletter_user.extract_name_from_email

    I18n.with_locale(@newsletter_user.lang) do
      render 'newsletter_mailer/welcome_user'
    end
  end

  # Preview Newsletter in browser
  def preview_in_browser
    raise ActionController::RoutingError, 'Not Found' if !all_conditions_respected? || !@newsletter.already_sent?
    @content = @newsletter.content

    I18n.with_locale(@newsletter_user.lang) do
      render 'newsletter_mailer/send_newsletter'
    end
  end

  private

  def set_vars
    @show_preview_link = false
  end

  def set_newsletter_setting
    @mailing_setting = MailingSetting.first.decorate
  end

  def all_conditions_respected?
    params[:token] && @newsletter_user.token == params[:token]
  end
end
