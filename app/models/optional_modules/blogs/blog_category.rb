# frozen_string_literal: true

#
# == BlogCategory Model
#
class BlogCategory < ApplicationRecord
  include Includes::BlogIncludable

  ATTRIBUTE ||= :name
  TRANSLATED_FIELDS ||= [:name, :slug].freeze

  translates(*TRANSLATED_FIELDS, fallbacks_for_empty_translations: true)
  active_admin_translates(*TRANSLATED_FIELDS, fallbacks_for_empty_translations: true) do
    validates ATTRIBUTE,
              presence: true
  end

  extend FriendlyId
  friendly_id :slug_candidates,
              use: [:slugged,
                    :globalize,
                    # :history,
                    :finders]

  # Model relations
  has_many :blogs, dependent: :destroy, inverse_of: :blog_category

  private

  def slug_candidates
    [
      ATTRIBUTE,
      [ATTRIBUTE, resource_id]
    ]
  end

  def resource_id
    id = self.class.where("#{ATTRIBUTE}": send(ATTRIBUTE)).count
    return id unless id.zero?
  end

  # FIXME: title_changed? or attribute_changed? seems to be broken
  def should_generate_new_friendly_id?
    new_record? || attribute_changed?(ATTRIBUTE) || super
  end
end

# == Schema Information
#
# Table name: blog_categories
#
#  id          :integer          not null, primary key
#  slug        :string(255)
#  blogs_count :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
