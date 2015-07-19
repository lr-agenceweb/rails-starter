# == Schema Information
#
# Table name: settings
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  title             :string(255)
#  subtitle          :string(255)
#  phone             :string(255)
#  email             :string(255)
#  address           :string(255)
#  city              :string(255)
#  postcode          :string(255)
#  geocode_address   :string(255)
#  latitude          :float(24)
#  longitude         :float(24)
#  show_map          :boolean          default(FALSE)
#  show_breadcrumb   :boolean          default(FALSE)
#  show_social       :boolean          default(TRUE)
#  should_validate   :boolean          default(TRUE)
#  maintenance       :boolean          default(FALSE)
#  logo_updated_at   :datetime
#  logo_file_size    :integer
#  logo_content_type :string(255)
#  logo_file_name    :string(255)
#  retina_dimensions :text(65535)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

#
# == Setting Model
#
class Setting < ActiveRecord::Base
  include Attachable

  translates :title, :subtitle, fallbacks_for_empty_translations: true
  active_admin_translates :title, :subtitle, fallbacks_for_empty_translations: true do
    validates :title, presence: true
  end

  retina!
  has_attachment :logo,
                 styles: {
                   large: '256x256>',
                   medium: '128x128>',
                   small: '64x64>',
                   thumb: '32x32>'
                 }

  validates_attachment_content_type :logo, content_type: %r{\Aimage\/.*\Z}

  validates :name,     presence: true
  validates :email,    presence: true, email_format: {}
  validates :postcode, presence: false, numericality: { only_integer: true }

  include DeletableAttachment

  def title_and_subtitle
    return "#{title}, #{subtitle}" if subtitle?
    title
  end

  def subtitle?
    !subtitle.blank?
  end
end
