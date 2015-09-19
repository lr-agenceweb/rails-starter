#
# == ApplicationDecorator
#
class ApplicationDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all

  @avatar_width = 64

  def title_for_given_name(name)
    header = content_tag(:h2, name, class: 'l-page-title', id: name)
    header
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
    send("#{model_name.underscore.downcase.singularize}_#{suffix}", model)
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

  def arbre_context
    @arbre_context ||= Arbre::Context.new({}, self)
    @arbre_context.dup
  end

  def arbre(&block)
    arbre_context.instance_eval(&block).to_s
  end

  def created_at
    I18n.l(model.created_at, format: :short)
  end

  def lang
    color = 'green'
    color = 'blue' if model.lang == 'fr'
    color = 'red' if model.lang == 'en'

    arbre do
      status_tag_deco I18n.t("active_admin.globalize.language.#{model.lang}"), color
    end
  end

  def status
    color = model.online? ? 'green' : 'red'
    status_tag_deco I18n.t("online.#{model.online}"), color
  end

  def show_as_gallery_d
    color = model.show_as_gallery? ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{model.show_as_gallery}"), color
  end

  def status_tag_deco(value, color)
    arbre do
      status_tag(value, color)
    end
  end

  def content?
    !model.content.blank?
  end

  def title?
    !model.title.blank?
  end

  def description?
    !model.description.blank?
  end
end
