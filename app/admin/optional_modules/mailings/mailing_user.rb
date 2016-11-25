# frozen_string_literal: true
ActiveAdmin.register MailingUser do
  menu parent: I18n.t('admin_menu.modules')

  permit_params :id,
                :fullname,
                :email,
                :lang,
                :token,
                :archive

  scope I18n.t('all'), :all, default: true
  scope I18n.t('mailing.archive'), :archive

  decorate_with MailingUserDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_archive_customer, if: proc { can? :toggle_archive_customer, Home } do |ids|
    MailingUser.find(ids).each { |item| item.toggle! :archive }
    redirect_back(fallback_location: admin_dashboard_path, notice: t('active_admin.batch_actions.flash'))
  end

  index do
    selectable_column
    column :fullname
    column :email
    column :created_at
    column :archive_status
    actions
  end

  show title: proc { resource.fullname } do
    arbre_cache(self, resource.cache_key) do
      attributes_table do
        row :fullname
        row :email
        row :lang
        row :created_at
        row :archive_status
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs I18n.t('formtastic.titles.mailing_user_details') do
      f.input :fullname
      f.input :email
      f.input :lang,
              collection: I18n.available_locales.map { |i| [i.to_s] },
              include_blank: false
      f.input :archive
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
