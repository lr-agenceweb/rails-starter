#
# == StringBox Decorator
#
class StringBoxDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def content
    model.content.html_safe if content?
  end

  def title
    title? ? '/' : model.title
  end
end
