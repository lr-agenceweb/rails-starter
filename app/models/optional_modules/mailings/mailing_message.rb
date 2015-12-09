# == Schema Information
#
# Table name: mailing_messages
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text(65535)
#  sent_at    :datetime
#  token      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == MailingMessage Model
#
class MailingMessage < ActiveRecord::Base
  include Tokenable

  translates :title, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :content

  def sent_at_message
    return I18n.t('newsletter.sent_on', date: I18n.l(sent_at, format: :long)) if already_sent?
    '/'
  end

  def already_sent?
    !sent_at.nil?
  end
end
