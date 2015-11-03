#
# == UserDecorator
#
class UserDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include AssetsHelper

  delegate_all
  decorates_association :posts

  def image_avatar
    # Website avatar present
    if model.avatar?
      retina_thumb_square(model)

    # Website avatar not present (use Gravatar)
    else
      gravatar_image_tag(model.email, alt: model.username, gravatar: { size: model.class.instance_variable_get(:@avatar_width) })
    end
  end

  def admin_link
    link_to I18n.t('active_admin.show'), admin_user_path(model)
  end

  def status
    color = 'green'
    color = 'red' if model.administrator?
    color = 'blue' if model.super_administrator?

    status_tag_deco(I18n.t("role.#{model.role_name}"), color)
  end
end
