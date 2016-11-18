# frozen_string_literal: true

#
# == Setting Model
#
class Setting < ApplicationRecord
  include MaxRowable
  include Assets::Settings::Paperclipable

  # Callbacks
  after_validation :clean_paperclip_errors

  # Globalize
  translates :title, :subtitle, fallbacks_for_empty_translations: true
  active_admin_translates :title, :subtitle, fallbacks_for_empty_translations: true do
    validates :title, presence: true
  end

  # Enum
  enum date_format: {
    with_time: 0,
    without_time: 1,
    ago: 2
  }

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
            inclusion: {
              in: Setting.date_formats.keys
            }

  def self.date_format_attributes_for_form
    date_formats.map do |date_format, _|
      [I18n.t("enum.#{model_name.i18n_key}.date_formats.#{date_format}"), date_format]
    end
  end

  def subtitle?
    subtitle.present?
  end

  def phone?
    phone.present?
  end

  def logo?
    logo.exists?
  end

  def logo_footer?
    logo_footer.exists?
  end

  private

  def clean_paperclip_errors
    errors.delete(:logo)
  end
end

# == Schema Information
#
# Table name: settings
#
#  id                       :integer          not null, primary key
#  name                     :string(255)
#  phone                    :string(255)
#  phone_secondary          :string(255)
#  email                    :string(255)
#  per_page                 :integer          default(3)
#  show_breadcrumb          :boolean          default(FALSE)
#  show_social              :boolean          default(TRUE)
#  show_qrcode              :boolean          default(FALSE)
#  show_admin_bar           :boolean          default(TRUE)
#  show_file_upload         :boolean          default(FALSE)
#  answering_machine        :boolean          default(FALSE)
#  picture_in_picture       :boolean          default(TRUE)
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
