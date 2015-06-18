ActiveAdmin.register Setting do
  menu priority: 100

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
                translations_attributes: [
                  :id, :locale, :title, :subtitle
                ]

  config.clear_sidebar_sections!
  actions :all, except: [:new, :destroy]

  index do
    column :name
    column :title do |resource|
      raw "<strong>#{resource.title}</strong>"
    end
    column :subtitle
    column :phone
    column :email
    column :address do |resource|
      raw "#{resource.address}<br>#{resource.postcode} - #{resource.city}"
    end

    translation_status
    actions
  end

  show do
    h3 resource.name
    attributes_table do
      row :title
      row :subtitle
      row :phone
      row :email
      row :address do
        raw "#{resource.address}<br>#{resource.postcode} - #{resource.city}"
      end
      row 'latlon' do
        raw "#{resource.latitude}, #{resource.longitude}"
      end
      row :show_map do
        status_tag("#{resource.show_map}", (resource.show_map? ? :ok : :warn))
      end
      row :show_breadcrumb do
        status_tag("#{resource.show_breadcrumb}", (resource.show_breadcrumb? ? :ok : :warn))
      end
      row :show_social do
        status_tag("#{resource.show_social}", (resource.show_social? ? :ok : :warn))
      end
      render 'show', resource: resource.decorate
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Paramètres du site' do
      f.translated_inputs 'Translated fields', switch_locale: false do |t|
        t.input :title, hint: 'Titre du site'
        t.input :subtitle, hint: 'Sous-titre du site'
      end
      f.input :name, hint: 'Nom du propriétaire du site'
      f.input :email, hint: 'Email d\'où seront reçus les messages de contact'
      f.input :phone, as: :phone, hint: 'Numéro de téléphone à afficher sur le site pour vous joindre'
      f.input :show_map, hint: 'Afficher ou non la carte sur la page contact'
      f.input :show_breadcrumb, hint: 'Afficher ou non le fil d\'ariane sur le site'
      f.input :show_social, hint: 'Afficher ou non les icônes de partage social sur le site'
    end

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

    f.actions
  end

  controller do
    before_action :set_setting, only: [:show]

    private

    def set_setting
      @setting = Setting.find(params[:id])
      gon_params
    end
  end
end
