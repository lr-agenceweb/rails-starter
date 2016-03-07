ActiveAdmin.register Newsletter do
  menu parent: I18n.t('admin_menu.modules')

  permit_params :id,
                :sent_at,
                translations_attributes: [
                  :id, :locale, :title, :content
                ]

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
  # == Controller
  #
  controller do
    include Skippable
    include Newsletterable
    include OptionalModules::NewsletterHelper

    def send_newsletter
      if params[:option] == 'subscribers'
        @newsletter.update_attributes(sent_at: Time.zone.now)
        @newsletter_users = NewsletterUser.subscribers.find_each
        count = @newsletter_users.count
      elsif params[:option] == 'testers'
        @newsletter_users = NewsletterUser.testers
        count = @newsletter_users.count
      end
      make_newsletter_with_i18n(@newsletter, @newsletter_users)

      flash[:notice] = "La newsletter est en train d'être envoyée à #{count} " + 'personne'.pluralize(count)
      redirect_to :back
    end

    def preview
      I18n.with_locale(params[:locale]) do
        @newsletter = Newsletter.find(params[:id])
        @title = @newsletter.title
        @content = @newsletter.content
        @newsletter_user = NewsletterUser.find_by(lang: params[:locale])
        render 'newsletter_mailer/send_newsletter', layout: 'newsletter'
      end
    end

    private

    def make_newsletter_with_i18n(newsletter, newsletter_users)
      I18n.available_locales.each do |locale|
        I18n.with_locale(locale) do
          newsletter_users.each do |user|
            if user.lang == locale.to_s
              NewsletterJob.set(wait: 3.seconds).perform_later(user, newsletter)
            end
          end
        end
      end
    end

    def set_newsletter
      @newsletter = Newsletter.find(params[:id])
    end
  end
end
