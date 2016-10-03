# frozen_string_literal: true

# == Schema Information
#
# Table name: blog_categories
#
#  id          :integer          not null, primary key
#  name        :string(255)      default("")
#  slug        :string(255)      default("")
#  blogs_count :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

#
# == BlogCategory Model
#
class BlogCategory < ActiveRecord::Base
  include Includes::BlogIncludable

  translates :name, :slug
  active_admin_translates :name, :slug do
    validates :name,
              presence: true
  end

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history, :globalize, :finders]

  # Models relations
  has_many :blogs, dependent: :destroy, inverse_of: :blog_category

  private

  def slug_candidates
    [[:name, :deduced_id]]
  end

  def deduced_id
    record_id = self.class.where(name: name).count
    return record_id + 1 unless record_id == 0
  end
end
