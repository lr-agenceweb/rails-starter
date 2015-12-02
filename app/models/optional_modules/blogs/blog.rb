# == Schema Information
#
# Table name: blogs
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  slug            :string(255)
#  content         :text(65535)
#  show_as_gallery :boolean          default(FALSE)
#  allow_comments  :boolean          default(TRUE)
#  online          :boolean          default(TRUE)
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_blogs_on_slug     (slug)
#  index_blogs_on_user_id  (user_id)
#

#
# == Blog Model
#
class Blog < ActiveRecord::Base
  include Scopable
  include Imageable
  include Videosable
  include Searchable
  include PrevNextable

  translates :title, :slug, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :slug, :content

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history, :globalize, :finders]

  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy
  accepts_nested_attributes_for :comments, reject_if: :all_blank, allow_destroy: true

  has_one :referencement, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :referencement, reject_if: :all_blank, allow_destroy: true

  delegate :description, :keywords, to: :referencement, prefix: true, allow_nil: true
  delegate :username, to: :user, prefix: true, allow_nil: true

  paginates_per 10

  scope :online, -> { where(online: true) }
end
