#
# == NewsletterSettingDecorator
#
class NewsletterSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
end
