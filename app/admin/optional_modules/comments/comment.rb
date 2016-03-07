ActiveAdmin.register Comment, as: 'PostComment' do
  menu parent: I18n.t('admin_menu.modules')
  includes :user

  permit_params :id,
                :username,
                :email,
                :comment,
                :user_id,
                :role,
                :validated,
                :signalled

  scope I18n.t('scope.all'), :all, default: true
  scope I18n.t('active_admin.globalize.language.fr'), :french, if: proc { @locales.length > 1 }
  scope I18n.t('active_admin.globalize.language.en'), :english, if: proc { @locales.length > 1 }
  scope I18n.t('comment.to_validate.scope'), :to_validate, if: proc { @comment_setting.should_validate? }
  scope I18n.t('comment.signalled.scope'), :signalled, if: proc { @comment_setting.should_signal? }

  decorate_with CommentDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new]

  batch_action :toggle_validated do |ids|
    Comment.find(ids).each { |item| item.toggle! :validated }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  batch_action :toggle_signalled do |ids|
    Comment.find(ids).each { |item| item.toggle! :signalled }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :author_with_avatar
    column :email_registered_or_guest
    column :lang if locales.length > 1
    column :status
    column :signalled_d if comment_setting.should_signal?
    column :link_and_image_source
    column :created_at

    actions
  end

  show do
    arbre_cache(self, resource.cache_key) do
      attributes_table do
        row :author_with_avatar
        row :email_registered_or_guest
        row :content
        row :lang if locales.length > 1
        row :status
        row :signalled_d if comment_setting.should_signal?
        row :link_and_image_source
        row :created_at
      end
    end
  end

  #
  # == Controller
  #
  controller do
    include Skippable

    before_action :set_comment_setting, only: [:index, :show]

    def scoped_collection
      super.includes user: [:role]
    end

    private

    def set_comment_setting
      @locales = I18n.available_locales
      @comment_setting = CommentSetting.first
    end
  end
end
