ActiveAdmin.register EventOrder do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params :id, :name

  # decorate_with EventSettingDecorator
  config.clear_sidebar_sections!

  index do
    selectable_column
    column :name
    actions
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('general') do
          f.input :name
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
