# frozen_string_literal: true
ActiveAdmin.register EventSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params do
    params = [:id,
              :prev_next,
              :event_order_id
             ]

    params.push :show_map if @map_module.enabled?
    params
  end

  decorate_with EventSettingDecorator
  config.clear_sidebar_sections!

  show title: I18n.t('activerecord.models.event_setting.one') do
    arbre_cache(self, resource.cache_key) do
      columns do
        column do
          attributes_table do
            bool_row :prev_next
            bool_row :show_map if map_module.enabled?
            row :event_order
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('general') do
          f.input :prev_next,
                  hint: I18n.t('form.hint.post.prev_next')

          if map_module.enabled?
            f.input :show_map,
                    hint: I18n.t('form.hint.event.show_map')
          end

          f.input :event_order,
                  as: :select,
                  collection: EventOrder.all,
                  include_blank: false,
                  hint: I18n.t('form.hint.event.event_order')
        end
      end
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include Skippable

    before_action :redirect_to_show, only: [:index], if: proc { current_user_and_administrator? && @event_module.enabled? }

    private

    def redirect_to_show
      redirect_to admin_event_setting_path(EventSetting.first), status: 301
    end
  end
end
