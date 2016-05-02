# frozen_string_literal: true
ActiveAdmin.register BlogCategory do
  menu parent: I18n.t('admin_menu.modules')
  # includes :translations

  permit_params do
    params = [:id, :name, :slug]
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

    f.inputs t('active_admin.details', model: I18n.t('activerecord.models.blog_category.one')) do
      f.input :name,
              hint: t('form.hint.blog_category.name')
      f.input :slug,
              hint: t('form.hint.blog_category.slug')
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
