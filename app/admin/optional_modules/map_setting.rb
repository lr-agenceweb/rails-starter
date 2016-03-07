ActiveAdmin.register MapSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params :id,
                :marker_icon,
                :marker_color,
                :show_map

  decorate_with MapSettingDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_online do |ids|
    Map.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  show title: I18n.t('activerecord.models.map_setting.one') do
    arbre_cache(self, resource.cache_key) do
      columns do
        column do
          panel t('active_admin.details', model: t('activerecord.models.map.one')) do
            attributes_table_for resource.decorate do
              row :marker_icon
              row :marker_color_d
            end
          end
        end

        column do
          panel t('activerecord.models.map.one') do
            render 'elements/map'
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.columns id: 'map-columns' do
      f.column do
        f.inputs 'Paramètre de la carte', class: 'map-settings' do
          f.input :marker_icon,
                  as: :select,
                  collection: MapSetting.allowed_markers,
                  hint: I18n.t('form.hint.map.marker_icon')

          f.input :marker_color,
                  hint: I18n.t('form.hint.map.marker_color'),
                  input_html: {
                    class: 'colorpicker',
                    value: f.object.marker_color.blank? ? '' : f.object.marker_color
                  }
        end
      end
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include OptionalModules::Mappable

    before_action :redirect_to_show, only: [:index], if: proc { @map_module.enabled? && current_user_and_administrator? }

    private

    def redirect_to_show
      redirect_to admin_map_setting_path(MapSetting.first), status: 301
    end
  end
end
