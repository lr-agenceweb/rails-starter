# == Schema Information
#
# Table name: settings
#
#  id                       :integer          not null, primary key
#  name                     :string(255)
#  title                    :string(255)
#  subtitle                 :string(255)
#  phone                    :string(255)
#  phone_secondary          :string(255)
#  email                    :string(255)
#  show_breadcrumb          :boolean          default(FALSE)
#  show_social              :boolean          default(TRUE)
#  show_qrcode              :boolean          default(FALSE)
#  should_validate          :boolean          default(TRUE)
#  maintenance              :boolean          default(FALSE)
#  twitter_username         :string(255)
#  logo_updated_at          :datetime
#  logo_file_size           :integer
#  logo_content_type        :string(255)
#  logo_file_name           :string(255)
#  logo_footer_updated_at   :datetime
#  logo_footer_file_size    :integer
#  logo_footer_content_type :string(255)
#  logo_footer_file_name    :string(255)
#  retina_dimensions        :text(65535)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

#
# == Setting Model
#
class Setting < ActiveRecord::Base
  include Attachable

  after_validation :clean_paperclip_errors

  translates :title, :subtitle, fallbacks_for_empty_translations: true
  active_admin_translates :title, :subtitle, fallbacks_for_empty_translations: true do
    validates :title, presence: true
  end

  retina!
  handle_attachment :logo,
                    styles: {
                      large: '256x256>',
                      medium: '128x128>',
                      small: '64x64>',
                      thumb: '32x32>'
                    }
  handle_attachment :logo_footer,
                    styles: {
                      large: '256x256>',
                      medium: '128x128>',
                      small: '64x64>',
                      thumb: '32x32>'
                    }

  validates_attachment :logo,
                       content_type: { content_type: %r{\Aimage\/.*\Z} },
                       size: { less_than: 2.megabyte }
  validates_attachment :logo_footer,
                       content_type: { content_type: %r{\Aimage\/.*\Z} },
                       size: { less_than: 2.megabyte }

  validates :name,  presence: true
  validates :email, presence: true, email_format: true

  include DeletableAttachment

  def title_and_subtitle
    return "#{title}, #{subtitle}" if subtitle?
    title
  end

  def subtitle?
    !subtitle.blank?
  end

  def clean_paperclip_errors
    errors.delete(:logo)
  end
end
