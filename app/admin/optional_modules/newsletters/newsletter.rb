# frozen_string_literal: true
ActiveAdmin.register Newsletter do
  menu parent: I18n.t('admin_menu.modules')

  permit_params do
    params = [:id, :sent_at]
    params.push(*post_attributes)
    params
  end

  decorate_with NewsletterDecorator
  config.clear_sidebar_sections!

  action_item :update_newsletter_setting, only: [:index, :show] do
    link_to I18n.t('active_admin.action_item.update_newsletter_setting'), edit_admin_newsletter_setting_path(NewsletterSetting.first)
  end

  index do
    selectable_column
    column :title
    column :preview
    column :status
    column :sent_at
    column :send_link

    translation_status
    actions
  end

  show do
    arbre_cache(self, resource.cache_key) do
      panel t('active_admin.details', model: active_admin_config.resource_label) do
        attributes_table_for resource.decorate do
          row :status
          row :sent_at
          row :preview
          row :live_preview
          row :list_subscribers
          row :send_link
        end
      end
    end
  end

  form do |f|
    render 'admin/newsletters/form', f: f
  end

  #
  # Controller
  # ============
  controller do
    include ActiveAdmin::ParamsHelper
    include Skippable
    include ModuleSettingable
    include Newsletterable
    include OptionalModules::NewsletterHelper

    # Callbacks
    before_action :set_newsletter_users,
                  only: [:send_newsletter]

    def send_newsletter
      count = @newsletter_users.count

      @newsletter_users.each do |newsletter_user|
        NewsletterJob.set(wait: 3.seconds).perform_later(newsletter_user, @newsletter)
      end

      flash[:notice] = "La newsletter est en train d'être envoyée à #{count} " + 'personne'.pluralize(count)
      redirect_back(fallback_location: admin_dashboard_path)
    end

    def preview
      I18n.with_locale(params[:locale]) do
        @newsletter = Newsletter.find(params[:id])
        @newsletter_user = NewsletterUser.find_by(lang: params[:locale])

        render 'newsletter_mailer/send_newsletter', layout: 'mailers/newsletter'
      end
    end

    private

    def set_newsletter_users
      if params[:option] == 'subscribers'
        @newsletter_users = NewsletterUser.subscribers.find_each
        @newsletter.update_attributes(sent_at: Time.zone.now)
      elsif params[:option] == 'testers'
        @newsletter_users = NewsletterUser.testers
      end
    end
  end
end
