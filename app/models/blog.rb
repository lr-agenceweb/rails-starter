# == Schema Information
#
# Table name: blogs
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  content    :text(65535)
#  online     :boolean          default(TRUE)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  fk_rails_08f7f1b196  (user_id)
#  index_blogs_on_slug  (slug) UNIQUE
#

#
# == Blog Model
#
class Blog < ActiveRecord::Base
  translates :title, :slug, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :slug, :content

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history, :globalize, :finders]

  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy
  accepts_nested_attributes_for :comments, reject_if: :all_blank, allow_destroy: true

  has_one :referencement, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :referencement, reject_if: :all_blank, allow_destroy: true

  has_many :pictures, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :pictures, reject_if: :all_blank, allow_destroy: true

  delegate :description, :keywords, to: :referencement, prefix: true, allow_nil: true
  delegate :username, to: :user, prefix: true, allow_nil: true

  scope :online, -> { where(online: true) }
end
