# == Schema Information
#
# Table name: newsletter_user_roles
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == NewsletterUserRole Model
#
class NewsletterUserRole < ActiveRecord::Base
  translates :title, fallbacks_for_empty_translations: true
  active_admin_translates :title
end
