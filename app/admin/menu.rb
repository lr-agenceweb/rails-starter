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

  # ActiveAdmin Sortable Tree options
  sortable tree: true,
           top_of_list: 0,
           max_levels: 2,
           collapsible: true

  action_item :new_menu_item, only: [:edit, :show] do
    link_to I18n.t('active_admin.action_item.new_menu_item'), new_admin_menu_path if can? :create, Menu
  end

  batch_action :toggle_value do |ids|
    Menu.find(ids).each do |menu|
      toggle_value = menu.online? ? false : true
      menu.update_attribute(:online, toggle_value)
    end
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index as: :sortable do
    label do |menu|
      raw(menu.decorate.title_sortable_tree)
    end
    actions
  end

  show title: :title_aa_show do
    attributes_table do
      row :title
      row :status
      row :show_in_header_d
      row :show_in_footer_d
      row :children_list
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
            f.input :parent_id,
                    collection: Menu.except_current_and_submenus(f.object),
                    include_blank: true,
                    as: :select,
                    input_html: { class: 'chosen-select' },
                    hint: I18n.t('form.hint.menu.parent_id')

            f.input :show_in_header
            f.input :show_in_footer
            f.input :online
          end
        end
      end

    end

    f.actions
  end

  # #
  # # == Controller
  # #
  # controller do
  # end
end
