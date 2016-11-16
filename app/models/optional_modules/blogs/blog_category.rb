# frozen_string_literal: true

#
# == BlogCategory Model
#
class BlogCategory < ApplicationRecord
  include Includes::BlogIncludable
  include Core::FriendlyGlobalizeSluggable

  ATTRIBUTE ||= :name
  TRANSLATED_FIELDS ||= [:name, :slug].freeze
  friendlyze_me # in FriendlyGlobalizeSluggable concern

  # Model relations
  has_many :blogs, dependent: :destroy, inverse_of: :blog_category
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
