# == Schema Information
#
# Table name: newsletters
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  content    :text(65535)
#  sent_at    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == Newsletter Model
#
class Newsletter < ActiveRecord::Base
  translates :title, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :content

  def sent_at_message
    return I18n.t('newsletter.sent_on', date: I18n.l(sent_at, format: :long)) unless sent_at.nil?
    '/'
  end

  def already_sent?
    !sent_at.nil?
  end
end
