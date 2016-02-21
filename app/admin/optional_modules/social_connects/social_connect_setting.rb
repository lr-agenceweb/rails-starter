ActiveAdmin.register SocialConnectSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params :id,
                :enabled,
                social_providers_attributes: [
                  :id, :name, :enabled
                ]

  decorate_with SocialConnectSettingDecorator
  config.clear_sidebar_sections!

  show title: proc { resource.title_aa_show } do
    columns do
      column do
        attributes_table do
          row :status
          resource.social_providers.each do |provider|
            row "social_#{provider.name}".to_sym
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('general') do
          f.input :enabled,
                  as: :boolean,
                  hint: I18n.t('form.hint.social_connect_setting.enabled')
        end
      end
    end

    columns do
      column do
        f.inputs t('activerecord.models.social_provider.other') do
          f.has_many :social_providers, heading: false, new_record: resource.social_providers.count >= 3 ? false : true do |item|
            item.input :name,
                       collection: SocialProvider.allowed_social_providers,
                       include_blank: false,
                       hint: I18n.t('form.hint.social_provider.name'),
                       input_html: {
                         disabled: item.object.new_record? || !current_user_and_administrator? ? false : :disbaled
                       }

            item.input :enabled,
                       as: :boolean,
                       hint: I18n.t('form.hint.social_provider.enabled')
          end
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
    before_action :redirect_to_show, only: [:index], if: proc { current_user_and_administrator? && @social_connect_module.enabled? }

    private

    def redirect_to_show
      redirect_to admin_social_connect_setting_path(SocialConnectSetting.first)
    end
  end
end
