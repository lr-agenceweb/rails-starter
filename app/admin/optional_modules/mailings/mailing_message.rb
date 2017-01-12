# frozen_string_literal: true
ActiveAdmin.register MailingMessage do
  menu parent: I18n.t('admin_menu.modules')

  permit_params do
    params = [:id, :token, :sent_at,
              :show_signature, mailing_user_ids: []]
    params.push(*post_attributes)
    params.push(*picture_attributes)
    params
  end

  scope I18n.t('all'), :all, default: true
  scope I18n.t('sent.true'), :sent
  scope I18n.t('sent.false'), :not_sent

  decorate_with MailingMessageDecorator
  config.clear_sidebar_sections!

  index do
    selectable_column
    image_column :image, style: :small do |r|
      r.picture.image if r.picture?
    end
    column :title
    column :preview
    column :status
    column :sent_at
    column :send_link

    actions
  end

  show do
    arbre_cache(self, resource.cache_key) do
      panel t('active_admin.details', model: active_admin_config.resource_label) do
        attributes_table_for resource.decorate do
          image_row :image, style: :medium do |r|
            r.picture.image if r.picture?
          end
          row :status
          row :sent_at
          row :preview
          row :send_link
          row :live_preview
        end
      end
    end
  end

  form html: { multipart: true } do |f|
    render 'admin/mailings/form', f: f
  end

  #
  # Controller
  # ============
  controller do
    include ActiveAdmin::ParamsHelper
    include Skippable
    include ModuleSettingable
    include Mailingable
    include OptionalModules::NewsletterHelper

    # Callbacks
    before_action :redirect_to_dashboard,
                  only: [:send_mailing_message],
                  if: proc {
                    params[:option].blank? || @mailing_message.token != params[:token]
                  }

    before_action :set_mailing_users,
                  only: [:send_mailing_message]

    def scoped_collection
      super.includes :picture, :translations
    end

    def create
      super do |success, _failure|
        success.html { make_redirect }
      end
    end

    def update
      super do |success, _failure|
        success.html { make_redirect }
      end
    end

    def send_mailing_message
      @mailing_users.each do |mailing_user|
        MailingMessageJob.set(wait: 3.seconds).perform_later(mailing_user, @mailing_message, @mailing_setting)
      end

      @mailing_message.update_attributes(sent_at: Time.zone.now)

      flash[:notice] = I18n.t('mailing.notice_sending', count: @mailing_users.count)
      redirect_back(fallback_location: admin_dashboard_path)
    end

    def preview
      @mailing_user = MailingUser.new(id: current_user.id, email: current_user.email, fullname: current_user.username.capitalize, token: Digest::MD5.hexdigest(current_user.email))

      render 'mailing_message_mailer/send_email', layout: 'mailers/mailing'
    end

    private

    def make_redirect
      if resource.should_redirect == true
        redirect_to edit_admin_mailing_message_path(resource.id)
      else
        redirect_to admin_mailing_message_path(resource.id)
      end
    end

    def set_mailing_users
      @mailing_users = @mailing_message.mailing_users if params[:option] == 'checked'
      @mailing_users = MailingUser.all if params[:option] == 'all'
    end
  end
end
