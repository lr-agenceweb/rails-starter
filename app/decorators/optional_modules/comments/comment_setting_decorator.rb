#
# == CommentSettingDecorator
#
class CommentSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
end
