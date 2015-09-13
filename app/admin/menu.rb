ActiveAdmin.register Menu do
  menu parent: I18n.t('admin_menu.config')
  includes :translations

  permit_params :id,
                :online,
                :show_in_footer,
                :ancestry,
                :parent_id,
                translations_attributes: [
                  :id, :locale, :title
                ]

  decorate_with MenuDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_value do |ids|
    Menu.find(ids).each do |menu|
      toggle_value = menu.online? ? false : true
      menu.update_attribute(:online, toggle_value)
    end
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  # index do
  #   selectable_column
  #   column :name_deco
  #   column :status
  #   column :description

  #   actions
  # end

  # show title: :title_aa_show do
  #   attributes_table do
  #     row :name_deco
  #     row :status
  #     row :description
  #   end
  # end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Configuration du menu' do
      columns do
        column do
          f.translated_inputs 'Translated fields', switch_locale: true do |t|
            t.input :title,
                    label: I18n.t('activerecord.attributes.post.title'),
                    hint: I18n.t('form.hint.title')
          end
        end

        column do
          f.input :parent_id,
                  collection: Menu.except_current_and_submenus(self),
                  include_blank: true,
                  as: :select,
                  input_html: { class: 'chosen-select' },
                  hint: 'Menu Parent'

          f.input :show_in_footer
          f.input :online
        end
      end

    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
  end
end
