ActiveAdmin.register Map, as: 'Plan' do
  menu parent: I18n.t('admin_menu.modules'),
       label: I18n.t('activerecord.models.map.one')

  permit_params :id,
                :marker_icon,
                :marker_color,
                :show_map,
                location_attributes: [
                  :id,
                  :address,
                  :city,
                  :postcode,
                  :geocode_address,
                  :latitude,
                  :longitude
                ]

  decorate_with MapDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_online do |ids|
    Map.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    row :full_address_inline
    column :status

    actions
  end

  show title: :title_aa_show do
    columns do
      column do
        panel t('active_admin.details', model: t('activerecord.models.plan.one')) do
          attributes_table_for resource.decorate do
            row :status
            row :full_address_inline
            row :marker_icon
            row :marker_color_deco
          end
        end
      end

      column do
        panel t('activerecord.models.map.one') do
          resource.decorate.map(true, true) # Mapbox
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Paramètres des modules' do
      f.input :show_map, hint: 'Afficher ou non la carte sur la page contact'
    end

    f.columns id: 'map-columns' do
      f.column do
        render 'admin/shared/locations/one', f: f, title: t('location.map.title'), full: true

        f.inputs 'Paramètre de la carte', class: 'map-settings' do
          f.input :marker_icon,
                  as: :select,
                  collection: Map.allowed_markers,
                  hint: I18n.t('form.hint.map.marker_icon'),
                  input_html: { class: 'chosen-select' }

          f.input :marker_color,
                  hint: I18n.t('form.hint.map.marker_color'),
                  input_html: {
                    class: 'colorpicker',
                    value: f.object.marker_color.blank? ? '' : f.object.marker_color
                  }
        end
      end

      f.column do
        panel t('activerecord.models.map.one') do
          f.object.decorate.map(true, true, true) # Mapbox
        end
      end
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include Mappable
    before_action :redirect_to_show, only: [:index], if: proc { @map_module.enabled? && current_user_and_administrator? }

    private

    def redirect_to_show
      redirect_to admin_plan_path(@map), status: 301
    end
  end
end
