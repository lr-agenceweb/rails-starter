ActiveAdmin.register Newsletter do
  menu parent: 'Newsletter'

  permit_params :id,
                :sent_at,
                translations_attributes: [
                  :id, :locale, :title, :content
                ]

  config.clear_sidebar_sections!

  index do
    selectable_column
    column :title do |resource|
      raw "<strong>#{resource.title}</strong>"
    end

    column 'Send' do |resource|
      render 'send', resource: resource
    end

    column 'Sent' do |resource|
      status_tag "#{resource.already_sent?}", (resource.already_sent? ? :ok : :warn)
    end

    column :sent_at do |resource|
      resource.sent_at_message
    end

    column 'Preview' do |resource|
      raw newsletter_preview(resource.id)
    end

    translation_status
    actions
  end

  show do
    h3 resource.title
    attributes_table do
      row :content do
        raw resource.content
      end

      row 'Send' do
        render 'send', resource: resource
      end

      row 'Sent' do
        status_tag "#{resource.already_sent?}", (resource.already_sent? ? :ok : :warn)
      end

      row :sent_at do
        resource.sent_at_message
      end

      row 'Preview' do
        raw newsletter_preview(resource.id)
      end
    end
  end

  form partial: 'form'

  #
  # == Controller
  #
  controller do
    include NewsletterHelper

    before_action :set_newsletter,
                  only: [
                    :show, :edit, :update, :destroy,
                    :send_newsletter, :send_newsletter_test
                  ]
    before_action :set_variables, only: [:preview]

    def send_newsletter
      @newsletter.update_attributes(sent_at: Time.zone.now)
      @newsletter_users = NewsletterUser.find_each
      make_newsletter_with_i18n(@newsletter, @newsletter_users)

      count = @newsletter_users.count
      flash[:notice] = "La newsletter est en train d'être envoyée à #{count} personnes"
      make_redirect
    end

    def send_newsletter_test
      @newsletter_testers = NewsletterUser.testers
      make_newsletter_with_i18n(@newsletter, @newsletter_testers)

      newsletter_testers = @newsletter_testers.map(&:email).join(', ')
      flash[:notice] = "La newsletter est en train d'être envoyée à #{newsletter_testers}"
      make_redirect
    end

    def preview
      I18n.with_locale(params[:locale]) do
        @newsletter = Newsletter.find(params[:id])
        @title = @newsletter.title
      end
      @preview_newsletter = true
      render layout: 'newsletter'
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

    def make_redirect
      redirect_to :back
    end

    def set_variables
      @host = Figaro.env.application_host
      @preview_newsletter = true
    end
  end
end
