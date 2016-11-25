# frozen_string_literal: true

#
# ApplicationDecorator
# =======================
class ApplicationDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all

  #
  # Columns
  # =========
  def title
    # Fixes: escaped symbols && AA form page breadcrumb
    safe_join [raw(model.title)] if title?
  end

  def content
    safe_join [raw(model.content)] if content?
  end

  def description
    safe_join [raw(model.description)] if description?
  end

  #
  # Avatar
  # ========
  def author_with_avatar_html(avatar, pseudo)
    html = []
    html << content_tag(:div) do
      concat avatar
      concat tag(:br)
      concat pseudo
    end
    safe_join [html]
  end

  #
  # Social
  # ========
  def social_share(element)
    if params[:action] == 'index' || params[:action] == 'new'
      awesome_share_buttons(@page.title, popup: true)
    else
      awesome_share_buttons(element.title, popup: true)
    end
  end

  #
  # Methods used in all decorators
  # ================================
  def self.collection_decorator_class
    PaginatingDecorator
  end

  #
  # ActiveAdmin views
  # ===================
  def arbre_context
    @arbre_context ||= Arbre::Context.new({}, self)
    @arbre_context.dup
  end

  def arbre(&block)
    arbre_context.instance_eval(&block).to_s
  end

  #
  # DateTime
  # ==========
  def created_at(format = :short)
    I18n.l(model.created_at, format: format)
  end

  def pretty_created_at(date_format)
    time = l(model.created_at, format: date_format.to_sym)
    title = l(model.created_at, format: :long)
    time_tag(model.created_at.to_datetime, time, class: 'date-format', title: title)
  end

  #
  # Files
  # =======
  def file_name_without_extension(assets)
    file = model.send("#{assets}_file_name")
    File.basename(file, File.extname(file)).humanize
  end

  #
  # Status tag
  # ============
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
end
