# frozen_string_literal: true
ActiveAdmin.register MapSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params do
    params = [:id, :marker_icon, :marker_color, :show_map]
    params.push(*location_attributes)
    params
  end

  decorate_with MapSettingDecorator
  config.clear_sidebar_sections!

  show title: I18n.t('activerecord.models.map_setting.one') do
    arbre_cache(self, resource.cache_key) do
      columns do
        column do
          panel t('active_admin.details', model: t('activerecord.models.map.one')) do
            attributes_table_for resource.decorate do
              bool_row :show_map
              row :marker_icon
              row :marker_color_preview
            end
          end
        end

        column do
          panel I18n.t('activerecord.models.location.one') do
            attributes_table_for resource.decorate do
              row :location_address
              row :location_postcode
              row :location_city
            end
          end
        end # column
      end # columns

      columns do
        # Mapbox
        panel('Mapbox') { render 'elements/map' } if show_map_contact
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.columns id: 'map-columns' do
      f.column do
        f.inputs t('formtastic.titles.map_setting_details'), class: 'map-settings' do
          f.input :show_map

          f.input :marker_icon,
                  as: :select,
                  collection: MapSetting.allowed_markers

          f.input :marker_color,
                  input_html: {
                    class: 'colorpicker',
                    value: f.object.marker_color.blank? ? '' : f.object.marker_color
                  }
        end

        render 'admin/locations/form', f: f, full: true
      end
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include ActiveAdmin::ParamsHelper
    include OptionalModules::Mappable

    before_action :redirect_to_show, only: [:index], if: proc { @map_module.enabled? && current_user_and_administrator? }

    private

    def redirect_to_show
      redirect_to admin_map_setting_path(MapSetting.first), status: 301
    end
  end
end
