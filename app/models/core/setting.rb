# frozen_string_literal: true

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
#  per_page                 :integer          default(3)
#  show_breadcrumb          :boolean          default(FALSE)
#  show_social              :boolean          default(TRUE)
#  show_qrcode              :boolean          default(FALSE)
#  show_map                 :boolean          default(FALSE)
#  show_admin_bar           :boolean          default(TRUE)
#  show_file_upload         :boolean          default(FALSE)
#  answering_machine        :boolean          default(FALSE)
#  date_format              :integer          default(0)
#  maintenance              :boolean          default(FALSE)
#  logo_updated_at          :datetime
#  logo_file_size           :integer
#  logo_content_type        :string(255)
#  logo_file_name           :string(255)
#  logo_footer_updated_at   :datetime
#  logo_footer_file_size    :integer
#  logo_footer_content_type :string(255)
#  logo_footer_file_name    :string(255)
#  retina_dimensions        :text(65535)
#  twitter_username         :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

#
# == Setting Model
#
class Setting < ActiveRecord::Base
  extend Enumerize
  include MaxRowable
  include Assets::Settings::Paperclipable

  # Callbacks
  after_validation :clean_paperclip_errors

  # Globalize
  translates :title, :subtitle, fallbacks_for_empty_translations: true
  active_admin_translates :title, :subtitle, fallbacks_for_empty_translations: true do
    validates :title, presence: true
  end

  # Model relations
  has_one :location, as: :locationable, dependent: :destroy
  accepts_nested_attributes_for :location, reject_if: :all_blank, allow_destroy: true

  # Delegate
  delegate :address, :postcode, :city, to: :location, prefix: true, allow_nil: true

  # Enum
  enumerize :date_format,
            in: {
              with_time: 0,
              without_time: 1,
              ago: 2
            },
            default: :with_time

  def self.per_page_values
    [1, 2, 3, 5, 10, 15, 20, 0]
  end

  # Validation rules
  validates :name,  presence: true
  validates :email, presence: true, email_format: true

  validates :per_page,
            presence: true,
            allow_blank: false,
            inclusion: per_page_values

  validates :date_format,
            presence: true,
            allow_blank: false,
            inclusion: date_format.values

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
