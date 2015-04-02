#
# == Post Model
#
class Post < ActiveRecord::Base
  translates :title, :slug, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :slug, :content

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history, :globalize, :finders]

  has_one :referencement, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :referencement, reject_if: :all_blank, allow_destroy: true

  delegate :description, :keywords, to: :referencement, prefix: true, allow_nil: true

  scope :online, -> { where(online: true) }

  self.inheritance_column = :type
  @child_classes = []

  def self.type
    %w(Home About Career Contact)
  end

  def self.inherited(child)
    @child_classes << child
    super # important!
  end

  def self.child_classes
    @child_classes
  end
end
