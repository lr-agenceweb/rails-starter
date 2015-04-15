#
# == CategoryDecorator
#
class CommentDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def prettify
  end

  def avatar
    if model.user_id.nil?
      gravatar_image_tag(model.email, alt: model.username) +
        content_tag(:p) do
          concat(content_tag(:small, model.username))
        end
    else
      retina_image_tag(comment.user, :avatar, :thumb) +
        content_tag(:p) do
          concat(content_tag(:small, model.user_username))
        end
    end
  end

  def content
    simple_format(comment.comment) +
      content_tag(:p, class: 'right') do
        concat(content_tag(:small, l(model.created_at, format: :without_time)))
      end
  end
end

# .row
#   .small-12.columns.panel
#     .row
#       .small-12.medium-2.columns
#         - if comment.user_id.nil?
#           = gravatar_image_tag(comment.email, alt: comment.username)
#           p
#             small = comment.username
#         - else
#           = retina_image_tag(comment.user, :avatar, :thumb)
#           p
#             small = comment.user_username

#       .small-12.medium-10.columns
#         = simple_format comment.comment
#         p.right = l(comment.created_at, format: :without_time)
