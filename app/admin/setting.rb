# frozen_string_literal: true
ActiveAdmin.register Setting do
  menu parent: I18n.t('admin_menu.config')

  permit_params do
    params = [:id,
              :name,
              :phone,
              :phone_secondary,
              :email,
              :per_page,
              :maintenance,
              :show_admin_bar,
              :show_file_upload,
              :date_format,
              :logo,
              :logo_footer,
              :delete_logo,
              :delete_logo_footer,
              :twitter_username,
              translations_attributes: [
                :id, :locale, :title, :subtitle
              ],
              location_attributes: [
                :id, :address, :city, :postcode, :geocode_address, :latitude, :longitude, :_destroy
              ]
             ]
    params.push :show_social if @social_module.enabled?
    params.push :show_qrcode if @qrcode_module.enabled?
    params.push :show_breadcrumb if @breadcrumb_module.enabled?
    params.push :show_map if @map_module.enabled?
    params
  end

  decorate_with SettingDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new, :destroy]

  show do
    arbre_cache(self, resource.cache_key) do
      render 'show', resource: resource
    end
  end

  form do |f|
    render 'form', f: f
  end

  #
  # == Controller
  #
  controller do
    before_action :redirect_to_dashboard, unless: proc { current_user_and_administrator? }
    before_action :redirect_to_show, only: [:index], if: proc { current_user_and_administrator? }

    private

    def redirect_to_show
      redirect_to admin_setting_path(Setting.first), status: 301
    end

    def redirect_to_dashboard
      redirect_to admin_dashboard_path, status: 301
    end
  end
end
