# frozen_string_literal: true
ActiveAdmin.register Slider do
  menu parent: I18n.t('admin_menu.modules')
  includes :page

  permit_params do
    params = [:id, :online, :page_id]
    params.push(*slider_attributes)
    params.push(*slides_attributes)
    params
  end

  decorate_with SliderDecorator
  config.clear_sidebar_sections!

  action_item :new_slider, only: [:show] do
    link_to I18n.t('active_admin.action_item.new_slider'), new_admin_slider_path if can? :create, Slider
  end

  batch_action :toggle_online, if: proc { can? :toggle_online, Slider } do |ids|
    Slider.find(ids).each { |item| item.toggle! :online }
    redirect_back(fallback_location: admin_dashboard_path, notice: t('active_admin.batch_actions.flash'))
  end

  batch_action :reset_cache, if: proc { can? :reset_cache, Slider } do |ids|
    Slider.find(ids).each(&:touch)
    redirect_back(fallback_location: admin_dashboard_path, notice: t('active_admin.batch_actions.reset_cache'))
  end

  index do
    selectable_column
    column :page
    bool_column :autoplay
    bool_column :hover_pause
    bool_column :loop
    bool_column :navigation
    bool_column :bullet
    column :time_to_show
    column :animate
    bool_column :online

    actions
  end

  show title: :title_aa_show do
    panel 'Slider prévisualisation' do
      render 'assets/sliders/show', slider: resource, force: true
    end

    arbre_cache(self, resource.cache_key) do
      columns do
        column do
          attributes_table do
            row :page
            bool_row :autoplay
            bool_row :hover_pause
            bool_row :loop
            bool_row :navigation
            bool_row :bullet
            row :time_to_show
            row :animate
            bool_row :online
          end
        end

        column do
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    render 'form', f: f
  end

  #
  # == Controller
  #
  controller do
    include ActiveAdmin::ParamsHelper
    include Skippable

    def scoped_collection
      super.includes slides: [:translations]
    end

    def edit
      @page_title = "#{t('active_admin.edit')} #{I18n.t('activerecord.models.slider.one')} page #{resource.decorate.page}"
    end
  end
end
