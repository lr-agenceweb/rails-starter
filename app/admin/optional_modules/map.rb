ActiveAdmin.register Map do
  menu parent: I18n.t('admin_menu.modules')

  permit_params :id,
                :address,
                :city,
                :postcode,
                :geocode_address,
                :latitude,
                :longitude,
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

  show do
    columns do
      column do
        panel t('active_admin.details', model: t('activerecord.models.map.one')) do
          attributes_table_for resource.decorate do
            row :status
            row :full_address
            row :latlon
          end
        end
      end

      column do
        panel 'Map' do
          # Mapbox
          resource.decorate.map(true, true)
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Paramètres des modules' do
      f.input :show_map, hint: 'Afficher ou non la carte sur la page contact'
    end

    f.columns do
      f.column do
        f.inputs 'Paramètre de la carte', class: 'map-settings' do
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
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    before_action :set_gon_params, only: [:show]

    private

    def set_gon_params
      mapbox_gon_params
    end
  end
end
