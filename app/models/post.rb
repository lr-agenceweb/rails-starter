#
# == Post Model
#
class Post < ActiveRecord::Base
  translates :title, :slug, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :slug, :content

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
