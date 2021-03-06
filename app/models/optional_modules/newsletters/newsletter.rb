# frozen_string_literal: true

#
# Newsletter Model
# ==================
class Newsletter < ApplicationRecord
  include Mailable

  # Translations
  translates :title, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :content
end

# == Schema Information
#
# Table name: newsletters
#
#  id         :integer          not null, primary key
#  slug       :string(255)
#  sent_at    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
