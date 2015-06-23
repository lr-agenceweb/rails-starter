#
# == CategoryDecorator
#
class CommentDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include AssetsHelper
  delegate_all

  def avatar
    width = 64

    # Not connected
    if model.user_id.nil?
      gravatar_image_tag(model.email, alt: model.username, gravatar: { size: width }) + pseudo

    # Connected
    else
      pseudo = pseudo(model.user_username)

      # Website avatar present
      if model.user.avatar?
        retina_thumb_square(comment.user) + pseudo

      # Website avatar not present (use Gravatar)
      else
        gravatar_image_tag(model.user.email, alt: model.user.username, gravatar: { size: width }) + pseudo
      end
    end
  end

  def content
    simple_format(comment.comment) +
      content_tag(:p, class: 'right') do
        concat(content_tag(:small, l(model.created_at, format: :without_time)))
      end
  end

  # Comment form depending if user is connected or not
  #
  # * *Args*    :
  #   - +f+ -> form object used
  #
  def form(f)
    if user_signed_in?
      form_connected(f)
    else
      form_not_connected(f)
    end
  end

  private

  def pseudo(name = model.username)
    content_tag(:p) do
      concat(content_tag(:small, name))
    end
  end

  def form_connected(f)
    content_tag(:div, class: 'row') do
      concat(content_tag(:div, class: 'small-12 medium-2 columns') do
        concat(retina_thumb_square(current_user))
        concat(pseudo(current_user.username))
      end)
      textarea_and_submit(f, 'medium-10')
    end
  end

  def form_not_connected(f)
    content_tag(:div, class: 'row') do
      concat(content_tag(:div, class: 'small-12 medium-6 columns') do
        concat(f.input :username)
        concat(f.input :email, as: :email)
      end)
      textarea_and_submit(f)
    end
  end

  def textarea_and_submit(f, klass = 'medium-6')
    concat(content_tag(:div, class: "small-12 #{klass} columns") do
      concat(f.input :comment, as: :text, label: false, input_html: { class: 'autosize' }) + # Textarea
      concat(f.input :nickname, label: false, input_html: { class: 'hide-for-small-up' }) + # Captcha
      concat(button_tag(class: 'submit-btn text-right tiny right') do # Submit button
        fa_icon('paper-plane')
      end)
    end)
  end
end
