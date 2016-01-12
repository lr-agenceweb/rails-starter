ActiveAdmin.register Blog do
  menu parent: I18n.t('admin_menu.modules')
  includes :translations

  permit_params :id,
                :type,
                :allow_comments,
                :show_as_gallery,
                :online,
                :user_id,
                translations_attributes: [
                  :id, :locale, :title, :slug, :content
                ],
                pictures_attributes: [
                  :id, :locale, :image, :online, :position, :_destroy
                ],
                video_platforms_attributes: [
                  :id, :url, :online, :position, :_destroy
                ],
                video_uploads_attributes: [
                  :id, :online, :position,
                  :video_file,
                  :video_autoplay,
                  :video_loop,
                  :video_controls,
                  :video_mute,
                  :_destroy,
                  video_subtitle_attributes: [
                    :id, :subtitle_fr, :subtitle_en, :online, :delete_subtitle_fr, :delete_subtitle_en
                  ]
                ],
                referencement_attributes: [
                  :id,
                  translations_attributes: [
                    :id, :locale, :title, :description, :keywords
                  ]
                ]

  decorate_with BlogDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_online do |ids|
    Blog.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    image_column :image, style: :small do |r|
      r.picture.image if r.picture?
    end
    column :title
    column :allow_comments_status
    column :show_as_gallery_d
    column :status
    translation_status
    column :author_with_avatar

    actions
  end

  show title: :title_aa_show do
    render 'admin/posts/show', resource: resource
  end

  form do |f|
    render 'admin/posts/form', f: f
  end

  #
  # == Controller
  #
  controller do
    include Skippable
    include Videoable

    before_create do |blog|
      blog.user_id = current_user.id
    end

    def create
      delete_key_before_save
      super
    end

    def update
      delete_key_before_save
      super
    end

    private

    def delete_key_before_save
      params[:blog].delete :allow_comments unless @comment_module.enabled?
    end
  end
end
