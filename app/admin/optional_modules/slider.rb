ActiveAdmin.register Slider do
  menu parent: I18n.t('admin_menu.modules')

  permit_params :id,
                :animate,
                :autoplay,
                :timeout,
                :hover_pause,
                :loop,
                :navigation,
                :bullet,
                :online,
                :category_id,
                slides_attributes: [
                  :id, :image, :online, :_destroy,
                  translations_attributes: [
                    :id, :locale, :title, :description
                  ]
                ]

  decorate_with SliderDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_value do |ids|
    Slider.find(ids).each do |slider|
      toggle_value = slider.online? ? false : true
      slider.update_attribute(:online, toggle_value)
    end
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :page
    column :autoplay
    column :hover_pause
    column :loop
    column :navigation
    column :bullet
    column :timeout
    column :animate
    column :status

    actions
  end

  show do
    columns do
      column do
        attributes_table do
          row :page
          row :status
          row :autoplay
          row :hover_pause
          row :loop
          row :navigation
          row :bullet
          row :timeout
          row :animate
        end
      end

      column do
      end
    end

    # panel 'Slider preview' do
    #   render 'optional_modules/sliders/show', slider: resource, force: true
    # end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('activerecord.models.slider.one') do
          f.input :autoplay
          f.input :hover_pause
          f.input :loop
          f.input :navigation
          f.input :bullet
          f.input :timeout
          f.input :animate,
                  collection: %w( fade slide ),
                  include_blank: false
        end
      end

      column do
        f.inputs t('additional') do
          f.input :online
          f.input :category_id,
                  as: :select,
                  collection: Category.visible_header,
                  include_blank: false,
                  input_html: { class: 'chosen-select' }
        end
      end
    end

    render 'admin/slides/many', f: f

    f.actions
  end
end
