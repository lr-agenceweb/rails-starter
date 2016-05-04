# frozen_string_literal: true
ActiveAdmin.register BlogSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params :id,
                :prev_next,
                :show_last_posts,
                :show_categories

  decorate_with BlogSettingDecorator
  config.clear_sidebar_sections!

  show title: I18n.t('activerecord.models.blog_setting.one') do
    arbre_cache(self, resource.cache_key) do
      columns do
        column do
          attributes_table do
            bool_row :prev_next
            bool_row :show_last_posts
            bool_row :show_categories
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('general') do
          f.input :prev_next,
                  hint: I18n.t('form.hint.post.prev_next')
          f.input :show_last_posts,
                  hint: I18n.t('form.hint.post.show_last_posts')
          f.input :show_categories,
                  hint: I18n.t('form.hint.post.show_categories')
        end
      end
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include Skippable

    before_action :redirect_to_show, only: [:index], if: proc { current_user_and_administrator? && @blog_module.enabled? }

    private

    def redirect_to_show
      redirect_to admin_blog_setting_path(BlogSetting.first), status: 301
    end
  end
end
