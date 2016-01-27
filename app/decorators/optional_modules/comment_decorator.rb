#
# == CommentDecorator
#
class CommentDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include AssetsHelper
  delegate_all

  # Avatar associated to comment
  #
  # * *Args*    :
  #
  def avatar
    # Not connected
    if model.user_id.nil?
      gravatar_image_tag(model.email, alt: model.username, gravatar: { size: model.class.instance_variable_get(:@avatar_width) })

    # Connected
    else
      # Website avatar present
      if model.user.avatar?
        retina_thumb_square(model.user)

      # Website avatar not present (use Gravatar)
      else
        gravatar_image_tag(model.user.email, alt: model.user.username, gravatar: { size: model.class.instance_variable_get(:@avatar_width) })
      end
    end
  end

  def avatar_with_pseudo
    avatar + pseudo
  end

  # Email associated to comment
  #
  # * *Args*    :
  #
  def mail
    model.user_id.nil? ? model.email : model.user.email
  end

  def message
    simple_format(model.comment)
  end

  def content
    simple_format(model.comment)
  end

  def comment_created_at
    content_tag(:small, time_tag(model.created_at.to_datetime, l(model.created_at, format: :without_time)))
  end

  # Article where the Comment comes from
  #
  #
  def source
    model.commentable_type.constantize.find(model.commentable_id)
  end

  # Link to article where the Comment comes from
  #
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

  # Image from article where Comment comes from
  #
  #
  def image_source
    from = source
    retina_image_tag from.pictures.first, :image, :small if from.pictures.present?
  end

  # Link and Image from article where Comment comes from
  #
  #
  def link_and_image_source
    content_tag(:p, image_source) + content_tag(:p, link_source)
  end

  def status
    color = model.validated? ? 'green' : 'orange'
    status_tag_deco(I18n.t("validate.#{model.validated}"), color)
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

  #
  # == Microdata
  #
  def microdata_meta
    h.content_tag(:div, '', itemscope: '', itemtype: 'http://schema.org/Comment') do
      concat(tag(:meta, itemprop: 'text', content: model.comment))
      concat(tag(:meta, itemprop: 'dateCreated', content: model.created_at.to_datetime))
      concat(tag(:meta, itemprop: 'name', content: pseudo_registered_or_guest))
    end
  end

  def pseudo(name = nil)
    name = pseudo_registered_or_guest if name.nil?
    content_tag(:span, '', itemprop: 'author', itemscope: '', itemtype: 'http://schema.org/Person') do
      concat(content_tag(:strong, name, itemprop: 'name', class: 'comment-author'))
    end
  end

  private

  def pseudo_registered_or_guest
    if model.user_id.nil?
      model.username
    else
      model.user_username
    end
  end

  def form_connected(f)
    content_tag(:div, class: 'row') do
      concat(content_tag(:div, class: 'small-12 medium-2 columns') do
        concat(content_tag(:div, retina_thumb_square(current_user), class: 'comment-avatar'))
        concat(pseudo(current_user.username))
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
      concat(f.input :comment, as: :text, input_html: { class: 'autosize' }) + # Textarea
      concat(f.input :nickname, label: false, input_html: { class: 'hide-for-small-up' }) + # Captcha
      concat(button_tag(class: 'submit-btn text-right tiny right') do # Submit button
        fa_icon('paper-plane')
      end)
    end)
  end
end
