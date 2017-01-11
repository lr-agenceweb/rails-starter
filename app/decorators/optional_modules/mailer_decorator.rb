# frozen_string_literal: true

#
# MailerDecorator
# =================
class MailerDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  #
  # Content
  # =========
  def preview
    html = []
    I18n.available_locales.each do |locale|
      html << link_to(t("active_admin.globalize.language.#{locale}"), send("preview_admin_#{resource_name}_#{locale}_path", model.id), target: :_blank)
      html << tag(:br)
    end
    safe_join [html]
  end

  def live_preview
    render "/admin/#{resource_name(with_gsub: true).pluralize}/iframe_preview", resource: model
  end

  def send_link
    render "/admin/#{resource_name(with_gsub: true).pluralize}/send", resource: model
  end

  def sent_at
    model.sent_at_message
  end

  #
  # Status tag
  # ============
  def status
    color = model.already_sent? ? 'red' : 'green'
    status_tag_deco(I18n.t("sent.#{model.already_sent?}"), color)
  end

  private

  def resource_name(with_gsub: false)
    return model.class.name.gsub('Message', '').underscore if with_gsub
    model.class.name.underscore
  end
end
