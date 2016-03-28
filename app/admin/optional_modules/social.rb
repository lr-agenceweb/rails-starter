ActiveAdmin.register Social do
  menu parent: I18n.t('admin_menu.modules')

  permit_params do
    params = [:id,
              :link,
              :enabled,
              :ikon,
              :delete_ikon,
              :font_ikon
             ]

    params.push :title, :kind if current_user.super_administrator?
    params
  end

  scope I18n.t('all'), :all, default: true
  scope I18n.t('social.share'), :share
  scope I18n.t('social.follow'), :follow

  decorate_with SocialDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_enabled do |ids|
    Social.find(ids).each { |item| item.toggle! :enabled }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :ikon_deco
    column :title
    column :kind
    column :link
    bool_column :enabled

    actions
  end

  show do
    arbre_cache(self, resource.cache_key) do
      attributes_table do
        row :ikon_deco
        row :title
        row :kind
        row :link unless resource.object.kind == 'share'
        bool_row :enabled
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.columns do
      f.column do
        f.inputs 'Paramètres du Réseau Social' do
          f.input :title,
                  collection: Social.allowed_title_social_network,
                  include_blank: false,
                  hint: I18n.t('form.hint.social.title'),
                  input_html: {
                    disabled: current_user.super_administrator? ? false : :disbaled
                  }

          f.input :kind,
                  collection: Social.allowed_kind_social_network,
                  hint: I18n.t('form.hint.social.kind'),
                  input_html: {
                    disabled: current_user.super_administrator? ? false : :disbaled
                  }

          if f.object.kind != 'share'
            f.input :link,
                    hint: I18n.t('form.hint.social.link')
          end
          f.input :enabled,
                  hint: I18n.t('form.hint.social.enabled')
        end
      end

      f.column do
        f.inputs 'Icône du Réseau Social' do
          f.input :ikon,
                  hint: f.object.decorate.ikon? ? f.object.decorate.ikon_deco : ''

          if f.object.decorate.ikon?
            f.input :delete_ikon,
                    as: :boolean,
                    hint: I18n.t('form.hint.social.delete_ikon')
          end

          f.input :font_ikon,
                  collection: Social.allowed_font_awesome_ikons,
                  include_blank: I18n.t('form.hint.social.font_ikon_blank'),
                  allow_blank: true,
                  hint: f.object.decorate.hint_by_ikon,
                  input_html: {
                    disabled: f.object.decorate.ikon? ? :disabled : false,
                    data: { placeholder: I18n.t('form.placeholder.social.font_ikon') }
                  }
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
  end
end
