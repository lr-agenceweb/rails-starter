#
# == ApplicationDecorator
#
class ApplicationDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all
  delegate :title, :description, :content

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

  def self.collection_decorator_class
    PaginatingDecorator
  end
end
