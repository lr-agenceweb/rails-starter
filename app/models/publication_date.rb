# frozen_string_literal: true

# == Schema Information
#
# Table name: publication_dates
#
#  id                  :integer          not null, primary key
#  publishable_id      :integer
#  publishable_type    :string(255)
#  published_later     :boolean          default(FALSE)
#  expired_prematurely :boolean          default(FALSE)
#  published_at        :datetime
#  expired_at          :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_publication_dates_on_publishable_type_and_publishable_id  (publishable_type,publishable_id)
#

#
# == PublicationDate Model
#
class PublicationDate < ActiveRecord::Base
  # Callbacks
  before_save :reset_published_at, unless: :published_later?
  before_save :reset_expired_at, unless: :expired_prematurely?

  # Model relations
  belongs_to :publishable, polymorphic: true, touch: true

  private

  def reset_published_at
    self.published_at = nil
  end

  def reset_expired_at
    self.expired_at = nil
  end
end
