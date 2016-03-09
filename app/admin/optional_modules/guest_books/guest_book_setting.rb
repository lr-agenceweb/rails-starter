ActiveAdmin.register GuestBookSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params :id, :should_validate

  decorate_with GuestBookSettingDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new]

  show title: I18n.t('activerecord.models.guest_book_setting.one') do
    arbre_cache(self, resource.cache_key) do
      attributes_table do
        row :should_validate
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs I18n.t('activerecord.models.guest_book_setting.one') do
      f.input :should_validate,
              as: :boolean,
              hint: I18n.t('form.hint.guest_book_setting.should_validate')
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include Skippable

    before_action :redirect_to_show, only: [:index], if: proc { current_user_and_administrator? && @guest_book_module.enabled? }

    private

    def redirect_to_show
      redirect_to admin_guest_book_setting_path(GuestBookSetting.first), status: 301
    end
  end
end
