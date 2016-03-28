ActiveAdmin.register Menu do
  menu parent: I18n.t('admin_menu.config')
  includes :translations

  permit_params :id,
                :online,
                :show_in_header,
                :show_in_footer,
                :ancestry,
                :parent_id,
                translations_attributes: [
                  :id, :locale, :title
                ]

  decorate_with MenuDecorator
  config.clear_sidebar_sections!

  action_item :new_menu_item, only: [:edit, :show] do
    link_to I18n.t('active_admin.action_item.new_menu_item'), new_admin_menu_path if can? :create, Menu
  end

  batch_action :toggle_online do |ids|
    Menu.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :title
    bool_column :online
    bool_column :show_in_header
    bool_column :show_in_footer
    actions
  end

  show title: :title_aa_show do
    arbre_cache(self, resource.cache_key) do
      attributes_table do
        row :title
        bool_row :online
        bool_row :show_in_header
        bool_row :show_in_footer
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Configuration du menu' do
      columns do
        column do
          f.translated_inputs 'Translated fields', switch_locale: true do |t|
            t.input :title,
                    label: I18n.t('activerecord.attributes.post.title'),
                    hint: I18n.t('form.hint.menu.title')
          end
        end

        column do
          f.inputs heading: false do
            f.input :show_in_header,
                    hint: I18n.t('form.hint.menu.show_in_header')
            f.input :show_in_footer,
                    hint: I18n.t('form.hint.menu.show_in_header')
            f.input :online,
                    hint: I18n.t('form.hint.menu.online')
          end
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
  end
end
