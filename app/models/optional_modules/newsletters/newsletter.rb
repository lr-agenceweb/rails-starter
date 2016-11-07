# frozen_string_literal: true

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
# Newsletter Model
# ====================
class Newsletter < ApplicationRecord
  include Mailable

  translates :title, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :content
end
