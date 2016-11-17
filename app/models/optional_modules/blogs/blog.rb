# frozen_string_literal: true

#
# == Blog Model
#
class Blog < ApplicationRecord
  include Scopable
  include PrevNextable
  include Publishable
  include Core::Userable
  include Core::Referenceable
  include Core::FriendlyGlobalizeSluggable
  include Includes::BlogIncludable
  include OptionalModules::Assets::Imageable
  include OptionalModules::Assets::Audioable
  include OptionalModules::Assets::VideoUploadable
  include OptionalModules::Assets::VideoPlatformable
  include OptionalModules::Commentable
  include OptionalModules::Searchable

  # Constants
  CANDIDATE ||= :title
  TRANSLATED_FIELDS ||= [:title, :slug, :content].freeze
  friendlyze_me # in FriendlyGlobalizeSluggable concern

  # Callbacks
  after_update :update_counter_cache, if: proc { online_changed? }

  # Models relation
  belongs_to :blog_category, inverse_of: :blogs, counter_cache: true

  # Validation rules
  validates :blog_category, presence: true

  # Scopes
  scope :online, -> { where(online: true) }
  scope :by_category, ->(category) { where(blog_category_id: category) }

  # Delegates
  delegate :name, to: :blog_category, prefix: true, allow_nil: true

  paginates_per 10

  private

  def update_counter_cache
    BlogCategory.increment_counter(:blogs_count, blog_category.id) if online?
    BlogCategory.decrement_counter(:blogs_count, blog_category.id) unless online?
  end
end

# == Schema Information
#
# Table name: blogs
#
#  id               :integer          not null, primary key
#  slug             :string(255)
#  show_as_gallery  :boolean          default(FALSE)
#  allow_comments   :boolean          default(TRUE)
#  online           :boolean          default(TRUE)
#  user_id          :integer
#  blog_category_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_blogs_on_blog_category_id  (blog_category_id)
#  index_blogs_on_slug              (slug)
#  index_blogs_on_user_id           (user_id)
#
