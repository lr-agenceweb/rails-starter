#
# == NewsletterUserDecorator
#
class NewsletterUserDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
end
