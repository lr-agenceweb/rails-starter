#
# == Referencement Model
#
class Referencement < ActiveRecord::Base
  translates :title, :description, :keywords, fallbacks_for_empty_translations: true
  active_admin_translates :title, :description, :keywords, fallbacks_for_empty_translations: true

  belongs_to :attachable, polymorphic: true
end
