# == Schema Information
#
# Table name: newsletter_user_roles
#
#  id            :integer          not null, primary key
#  rollable_id   :integer
#  rollable_type :string(255)
#  title         :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_newsletter_user_roles_on_rollable_type_and_rollable_id  (rollable_type,rollable_id)
#

#
# == NewsletterUserRole Model
#
class NewsletterUserRole < ActiveRecord::Base
  translates :title, fallbacks_for_empty_translations: true
  active_admin_translates :title

  belongs_to :rollable, polymorphic: true
end
