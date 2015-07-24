ActiveAdmin.register Event do
  menu parent: I18n.t('admin_menu.modules')

  permit_params :id,
                :url,
                :start_date,
                :end_date,
                :online,
                translations_attributes: [
                  :id, :locale, :title, :slug, :content
                ],
                pictures_attributes: [
                  :id, :image, :online, :_destroy
                ],
                referencement_attributes: [
                  :id,
                  translations_attributes: [
                    :id, :locale, :title, :description, :keywords
                  ]
                ]

  decorate_with EventDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_value do |ids|
    Event.find(ids).each do |event|
      toggle_value = event.online? ? false : true
      event.update_attribute(:online, toggle_value)
    end
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :title
    column :start_date
    column :end_date
    column :url
    column :status

    actions
  end

  show do
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.actions
  end
end
