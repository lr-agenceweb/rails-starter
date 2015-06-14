#
# == NewsletterHelper
#
module NewsletterHelper
  def newsletter_preview(newsletter_id)
    html = ''
    I18n.available_locales.each do |locale|
      newsletter_user = NewsletterUser.by_locale(locale).first
      unless newsletter_user.nil?
        html += link_to I18n.t("active_admin.globalize.language.#{locale}"), send("show_newsletter_#{locale}_path", newsletter_id, newsletter_user.id, newsletter_user.token), target: :_blank
      end
      html += '<br/>'
    end

    html
  end
end
