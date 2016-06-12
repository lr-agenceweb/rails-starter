# frozen_string_literal: true
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

  scope I18n.t('scope.all'), :all,
        default: true,
        if: proc { current_user_and_administrator? }
  scope I18n.t('active_admin.globalize.language.fr'), :french,
        if: proc { @locales.length > 1 && current_user_and_administrator? }
  scope I18n.t('active_admin.globalize.language.en'), :english,
        if: proc { @locales.length > 1 && current_user_and_administrator? }
  scope I18n.t('comment.to_validate.scope'), :to_validate,
        if: proc { @comment_setting.should_validate? && current_user_and_administrator? }
  scope I18n.t('comment.signalled.scope'), :signalled,
        if: proc { @comment_setting.should_signal? && current_user_and_administrator? }

  decorate_with CommentDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new]

  # Toggle comment validation on show view
  action_item :toggle_validated, only: [:show] do
    link_to I18n.t('active_admin.batch_actions.labels.toggle_validated'), toggle_validated_admin_post_comment_path(resource), method: :put, data: { confirm: I18n.t('active_admin.toggle_validated.confirm', verb: resource.validated? ? 'invalider' : 'valider', object_kind: I18n.t('activerecord.models.comment.one').downcase) }
  end

  member_action :toggle_validated, method: :put do
    resource.toggle! :validated
    redirect_to :back, notice: t('active_admin.toggle_validated.flash', verb: resource.validated? ? 'validé' : 'invalidé')
  end

  batch_action :toggle_validated,
               priority: 1,
               if: proc { can? :toggle_validated, Comment } do |ids|
    Comment.find(ids).each do |item|
      item.toggle! :validated
      email_comment_validated(item) if item.validated?
    end
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  batch_action :toggle_signalled,
               priority: 2,
               if: proc { can? :toggle_signalled, Comment } do |ids|
    Comment.find(ids).each { |item| item.toggle! :signalled }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  # Override destroy batch_action
  batch_action :destroy,
               priority: 3,
               confirm: I18n.t('active_admin.destroy.confirm', object_kind: I18n.t('activerecord.models.comment.one')) do |ids|
    Comment.find(ids).each { |item| item.destroy if can? :destroy, item }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :author_with_avatar
    column :email_registered_or_guest
    column :preview_content
    column :lang if locales.length > 1
    bool_column :validated
    bool_column :signalled if comment_setting.should_signal?
    column :link_and_image_source
    column :created_at

    actions
  end

  show do
    arbre_cache(self, resource.cache_key) do
      columns do
        column do
          attributes_table do
            row :author_with_avatar
            row :email_registered_or_guest
            row :content
          end
        end

        column do
          attributes_table do
            row :lang if locales.length > 1
            bool_row :validated
            bool_row :signalled if comment_setting.should_signal?
            row :link_and_image_source
            row :created_at
          end
        end
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

    def email_comment_validated(comment)
      CommentValidatedJob.set(wait: 3.seconds).perform_later(comment)
    end
  end
end
