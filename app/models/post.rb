# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id              :integer          not null, primary key
#  type            :string(255)
#  title           :string(255)
#  slug            :string(255)
#  content         :text(65535)
#  show_as_gallery :boolean          default(FALSE)
#  allow_comments  :boolean          default(TRUE)
#  online          :boolean          default(TRUE)
#  position        :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_posts_on_slug     (slug) UNIQUE
#  index_posts_on_user_id  (user_id)
#

#
# == Post Model
#
class Post < ActiveRecord::Base
  include Core::Userable
  include Core::Referenceable
  include OptionalModules::Assets::Imageable
  include OptionalModules::Assets::VideoPlatformable
  include OptionalModules::Assets::VideoUploadable
  include OptionalModules::Commentable
  include OptionalModules::Searchable
  include Positionable
  include PrevNextable

  translates :title, :slug, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :slug, :content

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history, :globalize, :finders]

  scope :online, -> { where(online: true) }
  scope :home, -> { where(type: 'Home') }
  scope :about, -> { where(type: 'About') }
  scope :by_user, -> (user_id) { where(user_id: user_id) }
  scope :allowed_for_rss, -> { where.not(type: 'Home').where.not(type: 'About').where.not(type: 'LegalNotice').where.not(type: 'Connection') }

  self.inheritance_column = :type
  @child_classes = []
  attr_reader :child_classes

  paginates_per 10

  def self.type
    %w(Home About Connection Contact)
  end

  def self.inherited(child)
    @child_classes << child
    super # important!
  end
end
