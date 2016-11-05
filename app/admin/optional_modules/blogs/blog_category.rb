# frozen_string_literal: true
ActiveAdmin.register BlogCategory do
  menu parent: I18n.t('admin_menu.modules')
  # includes :translations

  permit_params do
    params = [:id,
              translations_attributes: [
                :id, :locale, :name, :slug
              ]]
    params
  end

  decorate_with BlogCategoryDecorator
  config.clear_sidebar_sections!

  index do
    selectable_column
    column :name
    actions
  end

  show do
    attributes_table do
      row :name
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs t('formtastic.titles.blog_category') do
      f.translated_inputs 'Translated fields', switch_locale: true do |t|
        t.input :name
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
