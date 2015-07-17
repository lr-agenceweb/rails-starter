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
          render 'show', resource: setting.decorate
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs 'Paramètres du site' do
          columns do
            column do
              f.translated_inputs 'Translated fields', switch_locale: true do |t|
                t.input :title, hint: 'Titre du site'
                t.input :subtitle, hint: 'Sous-titre du site'
              end
            end

            column do
              f.input :logo, hint: retina_image_tag(object, :logo, :small)
              f.input :delete_logo,
                      as: :boolean,
                      hint: 'Si coché, le logo sera supprimé après mise à jour des paramètres'
            end
          end

          f.input :maintenance, hint: 'Mettre le site en maintenance a pour effet de rendre le contenu inaccessible sur internet'
        end
      end

      column do
        f.inputs 'Paramètres de l\'administrateur' do
          f.input :name, hint: 'Nom du propriétaire du site'
          f.input :email, hint: 'Email d\'où seront reçus les messages de contact'
          f.input :phone, as: :phone, hint: 'Numéro de téléphone à afficher sur le site pour vous joindre'
        end
      end
    end

    columns do
      column do
        f.inputs 'Paramètres des modules' do
          f.input :show_breadcrumb, hint: 'Afficher ou non le fil d\'ariane sur le site'
          f.input :show_social, hint: 'Afficher ou non les icônes de partage social sur le site'
          f.input :should_validate, hint: 'Si coché, les messages postés dans le livre d\'or et les commentaires ne seront pas visibles tant que vous ne les aurez pas validé manuellement'
          f.input :show_map, hint: 'Afficher ou non la carte sur la page contact'
        end
      end

      column do
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
