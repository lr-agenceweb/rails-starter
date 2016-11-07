# frozen_string_literal: true

# == Schema Information
#
# Table name: adult_settings
#
#  id            :integer          not null, primary key
#  redirect_link :string(255)
#  enabled       :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

#
# AdultSetting Model
# =====================
class AdultSetting < ApplicationRecord
  include MaxRowable

  # Translations
  translates :title, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :content

  # Validation rules
  validates :redirect_link,
            allow_blank: true,
            url: true
end
