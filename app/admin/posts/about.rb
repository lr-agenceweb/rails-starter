ActiveAdmin.register About do
  menu parent: 'Articles'

  permit_params :id,
                :type,
                :online,
                translations_attributes: [
                  :id, :locale, :title, :slug, :content
                ],
                referencement_attributes: [
                  :id,
                  translations_attributes: [
                    :id, :locale, :title, :description, :keywords
                  ]
                ]

  config.clear_sidebar_sections!

  index do
    selectable_column
    column :title do |resource|
      raw "<strong>#{resource.title}</strong>"
    end
    column :online

    translation_status
    actions
  end

  show do
    h3 resource.title
    attributes_table do
      row :content do
        raw resource.content
      end
      row :online do
        status_tag("#{resource.online}", (resource.online? ? :ok : :warn))
      end

      render 'admin/shared/referencement/show', resource: resource
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    render 'admin/shared/form_general', f: f
    render 'admin/shared/form_translation', f: f
    render 'admin/shared/referencement/form', f: f
    f.actions
  end

  #
  # == Controller
  #
  controller do
    before_action :set_about, only: [:show, :edit, :update, :destroy, :toggle_about_online]
    before_create do |about|
      about.type = 'About'
    end

    def toggle_about_online
      new_value = @about.online? ? false : true
      @about.update_attribute(:online, new_value)
      make_redirect
    end

    private

    def set_about
      @about = About.friendly.find(params[:id])
    end

    def make_redirect
      redirect_to :back
    end
  end
end
