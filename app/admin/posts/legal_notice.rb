# frozen_string_literal: true
ActiveAdmin.register LegalNotice do
  menu parent: I18n.t('admin_menu.posts')
  includes :translations, :user, :picture

  permit_params do
    params = [:type, :user_id]
    params.push(*general_attributes)
    params.push(*post_attributes)
    params
  end

  decorate_with LegalNoticeDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_online, if: proc { can? :toggle_online, LegalNotice } do |ids|
    LegalNotice.find(ids).each { |item| item.toggle! :online }
    redirect_back(fallback_location: admin_dashboard_path, notice: t('active_admin.batch_actions.flash'))
  end

  batch_action :reset_cache, if: proc { can? :reset_cache, LegalNotice } do |ids|
    LegalNotice.find(ids).each(&:touch)
    redirect_back(fallback_location: admin_dashboard_path, notice: t('active_admin.batch_actions.reset_cache'))
  end

  # Sortable
  sortable
  config.sort_order = 'position_asc'
  config.paginate   = false

  index do
    sortable_handle_column
    render 'admin/posts/index', object: self, hide_image_column: true, hide_comments_column: true
  end

  show title: :title_aa_show do
    arbre_cache(self, resource.cache_key) do
      h3 resource.title
      columns do
        column do
          panel t('active_admin.details', model: active_admin_config.resource_label) do
            attributes_table_for resource do
              row :content
              bool_row :online
            end
          end
        end
      end
    end
  end

  form do |f|
    f.inputs t('formtastic.titles.post_generals') do
      f.input :online
    end

    f.inputs t('formtastic.titles.post_translations') do
      f.translated_inputs 'Translated fields', switch_locale: true do |t|
        t.input :title
        t.input :content,
                input_html: { class: 'froala' }
      end
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include ActiveAdmin::ParamsHelper
    include ActiveAdmin::Postable
    include ActiveAdmin::Cachable
  end
end
