# frozen_string_literal: true

#
# == ApplicationDecorator
#
class ApplicationDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all

  #
  # == Avatar
  #
  def author_with_avatar_html(avatar, pseudo)
    content_tag(:div, nil, class: 'author-with-avatar') do
      concat("#{avatar} <br /> #{pseudo}".html_safe)
    end
  end

  #
  # == Dynamic menu link
  #
  def menu_link(model_name, absolute = false)
    suffix = absolute ? 'url' : 'path'
    return send("root_#{suffix}") if model_name == 'Home'
    send("#{model_name.underscore.downcase.pluralize}_#{suffix}")
  end

  def show_page_link(absolute = false)
    suffix = absolute ? 'url' : 'path'
    model_name = model.class.to_s
    return send("root_#{suffix}") if model_name == 'Home'
    return send("legal_notices_#{suffix}") if model_name == 'LegalNotice'
    return send("connections_#{suffix}") if model_name == 'Connection'
    return send("blog_category_blog_#{suffix}", model.blog_category, model) if model_name == 'Blog'
    send("#{model_name.underscore.singularize}_#{suffix}", model)
  end

  #
  # == Social
  #
  def social_share(element)
    if params[:action] == 'index' || params[:action] == 'new'
      awesome_share_buttons(@category.title, popup: true)
    else
      awesome_share_buttons(element.title, popup: true)
    end
  end

  #
  # == Methods used in all decorators
  #
  def self.collection_decorator_class
    PaginatingDecorator
  end

  #
  # == ActiveAdmin views
  #
  def arbre_context
    @arbre_context ||= Arbre::Context.new({}, self)
    @arbre_context.dup
  end

  def arbre(&block)
    arbre_context.instance_eval(&block).to_s
  end

  #
  # == DateTime
  #
  def created_at
    I18n.l(model.created_at, format: :short)
  end

  def pretty_created_at(date_format)
    time = l(model.created_at, format: date_format.to_sym)
    title = date_format == 'ago' ? l(model.created_at, format: :with_time) : time
    time_tag(model.created_at.to_datetime, time, class: 'date-format', title: title)
  end

  #
  # == Prev / Next
  #
  def prev_post
    prev_blog = model.fetch_prev
    model.is_a?(Blog) ? blog_category_blog_path(prev_blog.blog_category, prev_blog) : prev_blog
  end

  def next_post
    next_blog = model.fetch_next
    model.is_a?(Blog) ? blog_category_blog_path(next_blog.blog_category, next_blog) : next_blog
  end

  #
  # == Status tag
  #
  def status_tag_deco(value, color)
    arbre do
      status_tag(value, color)
    end
  end

  def lang
    color = 'blue' if model.lang == 'fr'
    color = 'red' if model.lang == 'en'
    status_tag_deco I18n.t("active_admin.globalize.language.#{model.lang}"), color
  end

  #
  # == Boolean
  #
  def content?
    !model.content.blank?
  end

  def title?
    !model.title.blank?
  end

  def description?
    !model.description.blank?
  end

  def location?
    !model.location.blank?
  end
end
