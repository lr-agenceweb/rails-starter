# frozen_string_literal: true

#
# == BlogDecorator
#
class BlogDecorator < PostDecorator
  include Draper::LazyHelpers
  delegate_all

  def title_aa_show
    I18n.t('post.title_aa_show', page: I18n.t('activerecord.models.blog.other'))
  end
end
