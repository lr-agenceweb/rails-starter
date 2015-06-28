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
                translations_attributes: [
                  :id, :locale, :title, :subtitle
                ]

  decorate_with SettingDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new, :destroy]

  index do
    column :name
    column :title
    column :subtitle
    column :phone
    column :email
    column :full_address

    translation_status
    actions
  end

  show do
    columns do
      column do
        panel 'Site parameters' do
          attributes_table_for setting.decorate do
            row :title
            row :subtitle
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
            row :show_map do
              status_tag("#{resource.show_map}", (resource.show_map? ? :ok : :warn))
            end
            row :show_breadcrumb do
              status_tag("#{resource.show_breadcrumb}", (resource.show_breadcrumb? ? :ok : :warn))
            end
            row :show_social do
              status_tag("#{resource.show_social}", (resource.show_social? ? :ok : :warn))
            end
          end
        end
      end
    end

    columns do
      column do
        panel 'Map' do
          render 'show', resource: setting.decorate
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Paramètres du site' do
      f.translated_inputs 'Translated fields', switch_locale: false do |t|
        t.input :title, hint: 'Titre du site'
        t.input :subtitle, hint: 'Sous-titre du site'
      end
    end

    f.inputs 'Paramètres des modules' do
      f.input :show_breadcrumb, hint: 'Afficher ou non le fil d\'ariane sur le site'
      f.input :show_social, hint: 'Afficher ou non les icônes de partage social sur le site'
      f.input :should_validate, hint: 'Si coché, les messages postés dans le livre d\'or et les commentaires ne seront pas visibles tant que vous ne les aurez pas validé manuellement'
      f.input :show_map, hint: 'Afficher ou non la carte sur la page contact'
    end

    f.inputs 'Paramètres de l\'administrateur' do
      f.input :name, hint: 'Nom du propriétaire du site'
      f.input :email, hint: 'Email d\'où seront reçus les messages de contact'
      f.input :phone, as: :phone, hint: 'Numéro de téléphone à afficher sur le site pour vous joindre'
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
