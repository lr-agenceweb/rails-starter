# frozen_string_literal: true
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

#
# == BlogCategory Model
#
class BlogCategory < ApplicationRecord
  include Includes::BlogIncludable

  translates :name, :slug, fallbacks_for_empty_translations: true
  active_admin_translates :name, :slug, fallbacks_for_empty_translations: true do
    validates :name,
              presence: true
  end

  extend FriendlyId
  friendly_id :slug_candidates,
              use: [:slugged,
                    :history,
                    :globalize,
                    :finders]

  # Models relations
  has_many :blogs, dependent: :destroy, inverse_of: :blog_category

  private

  def slug_candidates
    [[:name, :deduced_id]]
  end

  def deduced_id
    record_id = BlogCategory.where(name: name).count
    return record_id + 1 unless record_id.zero?
  end

  def should_generate_new_friendly_id?
    new_record? || attribute_changed?(:name)
  end
end
