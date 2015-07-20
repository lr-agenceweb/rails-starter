ActiveAdmin.register Setting do
  menu parent: 'configuration'

  permit_params :id,
                :name,
                :phone,
                :email,
                :address,
                :city,
                :postcode,
                :geocode_address,
                :latitude,
                :longitude,
                :show_map,
                :show_breadcrumb,
                :show_social,
                :should_validate,
                :maintenance,
                :logo,
                :delete_logo,
                translations_attributes: [
                  :id, :locale, :title, :subtitle
                ]

  decorate_with SettingDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new, :destroy]

  index do
    column :logo
    column :name
    column :title
    column :subtitle
    column :phone
    column :email
    column :full_address
    column :maintenance

    translation_status
    actions
  end

  show do
    columns do
      column do
        panel 'Site parameters' do
          attributes_table_for setting.decorate do
            row :logo
            row :title
            row :subtitle
            row :maintenance
          end
        end
      end

      column do
        panel 'Administrator informations' do
          attributes_table_for setting.decorate do
            row :name
            row :phone
            row :email
            row :full_address
            row :latlon
          end
        end
      end

      column do
        panel 'Modules informations' do
          attributes_table_for setting.decorate do
            row :map_status
            row :breadcrumb
            row :social
          end
        end
      end
    end

    columns do
      column do
        panel 'Map' do
          render 'map', resource: setting.decorate
        end
      end
    end
  end

  form do |f|
    render 'form', f: f
  end

  #
  # == Controller
  #
  controller do
    before_action :set_setting, only: [:show]
    before_action :redirect_to_show, only: [:index]

    private

    def redirect_to_show
      redirect_to admin_setting_path(@setting)
    end

    def set_setting
      @setting = Setting.find(params[:id])
      gon_params
    end
  end
end
