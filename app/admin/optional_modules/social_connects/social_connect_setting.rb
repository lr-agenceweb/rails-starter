# frozen_string_literal: true
ActiveAdmin.register SocialConnectSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params do
    params = [:id,
              :enabled,
              social_providers_attributes: [
                :id, :enabled
              ]]
    # params.push social_providers_attributes: [:name], if: proc { current_user.super_administrator? }
    params
  end

  decorate_with SocialConnectSettingDecorator
  config.clear_sidebar_sections!

  show title: proc { resource.title_aa_show } do
    arbre_cache(self, resource.cache_key) do
      columns do
        column do
          attributes_table do
            bool_row :enabled
            resource.social_providers.each do |provider|
              bool_row "social_#{provider.name}".to_sym
            end
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('formtastic.titles.social_connect_setting_details') do
          f.input :enabled
        end
      end
    end

    columns do
      column do
        f.inputs t('formtastic.titles.social_provider_details') do
          f.has_many :social_providers, heading: false, new_record: resource.social_providers.count >= 3 ? false : true do |item|
            item.input :name,
                       collection: SocialProvider.allowed_social_providers,
                       include_blank: false,
                       input_html: {
                         disabled: item.object.new_record? ? false : :disbaled
                       }

            item.input :enabled
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
      redirect_to admin_social_connect_setting_path(SocialConnectSetting.first), status: 301
    end
  end
end
