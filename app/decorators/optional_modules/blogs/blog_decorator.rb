# frozen_string_literal: true

#
# BlogDecorator
# ===============
class BlogDecorator < PostDecorator
  include Draper::LazyHelpers
  delegate_all

  #
  # ActiveAdmin
  # =============
  def title_aa_show
    I18n.t('post.title_aa_show', page: I18n.t('activerecord.models.blog.one'), title: model.title)
  end

  def create_blog_category_link
    html = []
    html << safe_join([raw(t('blog_category.missing'))])
    html << link_to(safe_join([raw(t('blog_category.add'))]), new_admin_blog_category_path, class: 'button')
    safe_join [html], ' '
  end
end
