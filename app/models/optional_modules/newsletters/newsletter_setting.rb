#
# == NewsletterSetting Model
#
class NewsletterSetting < ActiveRecord::Base
  translates :title_subscriber, :content_subscriber, fallbacks_for_empty_translations: true
  active_admin_translates :title_subscriber, :content_subscriber
end
