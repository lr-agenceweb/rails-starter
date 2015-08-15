ActiveAdmin.register Map, as: 'Plan' do
  menu parent: I18n.t('admin_menu.modules'),
       label: I18n.t('activerecord.models.map.one')

  permit_params :id,
                :address,
                :city,
                :postcode,
                :geocode_address,
                :latitude,
                :longitude,
                :marker_icon,
                :marker_color,
                :show_map

  decorate_with MapDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_value do |ids|
    Map.find(ids).each do |map|
      toggle_value = map.online? ? false : true
      map.update_attribute(:show_map, toggle_value)
    end
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :address
    column :city
    column :postcode
    column :geocode_address
    column :latitude
    column :longitude
    column :status

    actions
  end

  show title: :title_aa_show do
    columns do
      column do
        panel t('active_admin.details', model: t('activerecord.models.plan.one')) do
          attributes_table_for resource.decorate do
            row :status
            row :full_address
            row :latlon
            row :geocode_address
            row :marker_icon
            row :marker_color_deco
          end
        end
      end

      column do
        panel 'Map' do
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

          f.input :geocode_address,
                  hint: 'Ce champs est utilisé pour récupérer les coordonnées latitude / longitude de la position et centrer la carte (n\'est pas affichée)',
                  input_html: { id: 'gmaps-input-address' }

          f.input :address,
                  hint: 'Adresse affichée sur le site'
          f.input :city
          f.input :postcode
          f.input :latitude,
                  label: false,
                  input_html: { id: 'gmaps-output-latitude', class: 'hide' }
          f.input :longitude,
                  label: false,
                  input_html: { id: 'gmaps-output-longitude', class: 'hide' }
        end
      end

      f.column do
        panel 'Map' do
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
    include MapHelper
    before_action :redirect_to_show, only: [:index], if: proc { @map_module.enabled? && current_user_and_administrator? }

    private

    def redirect_to_show
      redirect_to admin_plan_path(@map)
    end
  end
end
