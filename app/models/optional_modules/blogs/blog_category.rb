# frozen_string_literal: true

# == Schema Information
#
# Table name: blog_categories
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  slug        :string(255)      not null
#  blogs_count :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

#
# == BlogCategory Model
#
class BlogCategory < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history, :globalize, :finders]

  translates :name, :slug
  active_admin_translates :name, :slug do
    validates :name,
              uniqueness: true,
              presence: true
  end

  has_many :blogs, dependent: :destroy, inverse_of: :blog_category
end
