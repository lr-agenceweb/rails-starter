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

  def menu_link(model_name, absolute = false)
    case model_name
    when 'Home'
      return root_path unless absolute
      root_url
    when 'About'
      return abouts_path unless absolute
      abouts_url
    when 'GuestBook'
      return guest_books_path unless absolute
      guest_books_url
    when 'Search'
      return searches_path unless absolute
      searches_url
    when 'Blog'
      return blogs_path unless absolute
      blogs_url
    when 'Contact'
      return new_contact_path unless absolute
      new_contact_url
    else
      return '#'
    end
  end

  def show_page_link(absolute = false)
    case model.class.name
    when 'Home'
      return root_url unless absolute
      root_url
    when 'About'
      return about_path(model) unless absolute
      about_url(model)
    when 'Blog'
      return blog_path(model) unless absolute
      blog_url(model)
    else
      return '#'
    end
  end

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
      status_tag(I18n.t("active_admin.globalize.language.#{model.lang}"), color)
    end
  end

  def status_tag_deco(value, color)
    arbre do
      status_tag(value, color)
    end
  end
end
