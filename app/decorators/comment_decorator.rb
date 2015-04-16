#
# == CategoryDecorator
#
class CommentDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def avatar
    if model.user_id.nil?
      gravatar_image_tag(model.email, alt: model.username) + pseudo
    else
      retina_image_tag(comment.user, :avatar, :thumb) + pseudo(model.user_username)
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
    # Connected
    if user_signed_in?
      content_tag(:div, class: 'row') do
        concat(content_tag(:div, class: 'small-12 medium-2 columns') do
          if current_user.avatar?
            concat(retina_image_tag current_user, :avatar, :small)
          else
            concat(gravatar_image_tag current_user.email, alt: current_user.username)
          end
          concat(pseudo(current_user.username))
        end)
        textarea_and_submit(f, 'medium-10')
      end

    # Not connected
    else
      content_tag(:div, class: 'row') do
        concat(content_tag(:div, class: 'small-12 medium-6 columns') do
          concat(f.input :username)
          concat(f.input :email, as: :email)
        end)
        textarea_and_submit(f)
      end
    end
  end

  private

  def pseudo(name = model.username)
    content_tag(:p) do
      concat(content_tag(:small, name))
    end
  end

  def textarea_and_submit(f, klass = 'medium-6')
    concat(content_tag(:div, class: "small-12 #{klass} columns") do
      concat(f.input :comment, as: :text, label: false, input_html: { class: 'autosize' }) +
      concat(button_tag(class: 'submit-btn text-right tiny right') do
        fa_icon('paper-plane')
      end)
    end)
  end
end
