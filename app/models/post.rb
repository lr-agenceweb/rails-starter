# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  type       :string(255)
#  title      :string(255)
#  slug       :string(255)
#  content    :text(65535)
#  online     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_posts_on_slug  (slug) UNIQUE
#

#
# == Post Model
#
class Post < ActiveRecord::Base
  include PrimaryAttachment
  translates :title, :slug, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :slug, :content

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history, :globalize, :finders]

  has_one :referencement, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :referencement, reject_if: :all_blank, allow_destroy: true

  delegate :description, :keywords, to: :referencement, prefix: true, allow_nil: true

  scope :online, -> { where(online: true) }
  scope :home, -> { where(type: 'Home') }
  scope :about, -> { where(type: 'About') }

  self.inheritance_column = :type
  @child_classes = []
  attr_reader :child_classes

  def self.type
    %w(Home About Contact)
  end

  def self.inherited(child)
    @child_classes << child
    super # important!
  end
end
