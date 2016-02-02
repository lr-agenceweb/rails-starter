#
# == CommentDecorator
#
class CommentDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include AssetsHelper
  delegate_all

  #
  # == Extract pseudo and email from comment
  #
  def pseudo_registered_or_guest
    name = model.try(:user_id).nil? ? model.username : model.user_username
    name.capitalize
  end

  def email_registered_or_guest
    model.try(:user_id).nil? ? model.email : model.user_email
  end

  #
  # == Avatar associated to comment
  #
  def avatar
    # Not connected
    if model.try(:user_id).nil?
      gravatar_image_tag(model.email, alt: model.username, gravatar: { size: model.class.instance_variable_get(:@avatar_width) })

    # Connected
    else
      # Website avatar present
      if model.user.avatar?
        retina_thumb_square(model.user)

      # Website avatar not present (use Gravatar)
      else
        gravatar_image_tag(model.user.email, alt: model.user_username, gravatar: { size: model.class.instance_variable_get(:@avatar_width) })
      end
    end
  end

  def author_with_avatar
    content_tag(:div, nil, class: 'author-with-avatar') do
      concat("#{avatar} <br /> #{pseudo_registered_or_guest}".html_safe)
    end
  end

  #
  # == Content
  #
  def message
    simple_format(model.comment)
  end

  def content
    message
  end

  def comment_created_at
    content_tag(:small, time_tag(model.created_at.to_datetime, l(model.created_at, format: :without_time)))
  end

  #
  # == Article where the Comment comes from
  #
  def source
    model.commentable_type.constantize.find(model.commentable_id)
  end

  #
  # == Link to article where the Comment comes from
  #
  def link_source
    from = source
    if model == 'Post'
      link = send("#{from.type.downcase.underscore.singularize}_path", from)
    else
      link = send('blog_path', from)
    end
    link_to from.title, link, target: :_blank
  end

  #
  # == Image from article where Comment comes from
  #
  def image_source
    from = source
    retina_image_tag from.pictures.first, :image, :small if from.pictures.present?
  end

  #
  # == Link and Image from article where Comment comes from
  #
  def link_and_image_source
    content_tag(:p, image_source) + content_tag(:p, link_source)
  end

  def status
    color = model.validated? ? 'green' : 'orange'
    status_tag_deco(I18n.t("validate.#{model.validated}"), color)
  end

  def signalled_d
    color = model.signalled? ? 'red' : 'green'
    status_tag_deco(I18n.t("#{model.signalled}"), color)
  end

  #
  # == Comment form depending if user is connected or not
  #
  def form(f)
    if user_signed_in?
      form_connected(f)
    else
      form_not_connected(f)
    end
  end

  #
  # == Microdata
  #
  def microdata_meta
    h.content_tag(:div, '', itemscope: '', itemtype: 'http://schema.org/Comment') do
      concat(tag(:meta, itemprop: 'text', content: model.comment))
      concat(tag(:meta, itemprop: 'dateCreated', content: model.created_at.to_datetime))
      concat(h.content_tag(:div, nil, itemprop: 'author', itemscope: '', itemtype: 'http://schema.org/Person') do
        concat(tag(:meta, itemprop: 'name', content: pseudo_registered_or_guest))
      end)
    end
  end

  private

  def pseudo(name = nil)
    name = pseudo_registered_or_guest if name.nil?
    content_tag(:strong, name, class: 'comment-author')
  end

  def form_connected(f)
    content_tag(:div, class: 'row') do
      concat(content_tag(:div, class: 'small-12 medium-2 columns') do
        concat(content_tag(:div, nil, class: 'auhtor-with-avatar') do
          concat(content_tag(:div, retina_thumb_square(current_user), class: 'comment-avatar'))
          concat(pseudo(current_user.username))
        end)
      end)
      textarea_and_submit(f, 'medium-10')
    end
  end

  def form_not_connected(f)
    content_tag(:div, class: 'row') do
      concat(content_tag(:div, class: 'small-12 medium-6 columns') do
        concat(f.input :username)
      end)
      concat(content_tag(:div, class: 'small-12 medium-6 columns') do
        concat(f.input :email, as: :email)
      end)
      textarea_and_submit(f, 'small-12')
    end
  end

  def textarea_and_submit(f, klass = 'medium-6')
    concat(content_tag(:div, class: "small-12 #{klass} columns") do
      concat(f.hidden_field :lang, value: params[:locale]) + # Lang
      concat(f.input :comment, as: :text, input_html: { class: 'autosize', style: 'height: 120px' }) + # Textarea
      concat(f.input :nickname, label: false, input_html: { class: 'hide-for-small-up' }) + # Captcha
      concat(f.input :parent_id, as: :hidden, label: false, input_html: { class: 'hide-for-small-up' }) +
      concat(content_tag(:div, class: 'submit-and-loader') do
        concat(image_tag(Figaro.env.loader_spinner_img, class: 'submit-loader')) + # Loader div
        concat(button_tag(class: 'submit-btn text-right tiny') do # Submit button
          fa_icon('paper-plane')
        end)
      end)
    end)
  end
end
