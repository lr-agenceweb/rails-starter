# frozen_string_literal: true

# == Schema Information
#
# Table name: blogs
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  slug             :string(255)
#  content          :text(65535)
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

#
# == Blog Model
#
class Blog < ActiveRecord::Base
  include Scopable
  include Core::Userable
  include Core::Referenceable
  include OptionalModules::Assets::Imageable
  include OptionalModules::Assets::Audioable
  include OptionalModules::Assets::VideoUploadable
  include OptionalModules::Assets::VideoPlatformable
  include OptionalModules::Commentable
  include OptionalModules::Searchable
  include PrevNextable

  after_update :update_counter_cache, if: proc { online_changed? }

  translates :title, :slug, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :slug, :content

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history, :globalize, :finders]

  belongs_to :blog_category, inverse_of: :blogs, counter_cache: true

  delegate :name, to: :blog_category, prefix: true, allow_nil: true

  validates :blog_category, presence: true

  paginates_per 10

  scope :online, -> { where(online: true) }
  scope :by_category, -> (category) { where(blog_category_id: category) }

  private

  def update_counter_cache
    BlogCategory.increment_counter(:blogs_count, blog_category.id) if online?
    BlogCategory.decrement_counter(:blogs_count, blog_category.id) unless online?
  end
end
