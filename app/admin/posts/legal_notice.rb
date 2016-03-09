ActiveAdmin.register LegalNotice do
  menu parent: I18n.t('admin_menu.posts')
  includes :translations

  permit_params :id,
                :type,
                :online,
                :user_id,
                translations_attributes: [
                  :id, :locale, :title, :content
                ]

  decorate_with LegalNoticeDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_online do |ids|
    About.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  batch_action :reset_cache do |ids|
    About.find(ids).each(&:touch)
    redirect_to :back, notice: t('active_admin.batch_actions.reset_cache')
  end

  # Sortable
  sortable
  config.sort_order = 'position_asc'
  config.paginate   = false

  index do
    sortable_handle_column
    render 'admin/posts/index', object: self
  end

  show title: :title_aa_show do
    arbre_cache(self, resource.cache_key) do
      h3 resource.title
      columns do
        column do
          panel t('active_admin.details', model: active_admin_config.resource_label) do
            attributes_table_for resource do
              row :content
              row :status
            end
          end
        end
      end
    end
  end

  form do |f|
    f.inputs 'Général' do
      f.input :online,
              label: I18n.t('form.label.online'),
              hint: I18n.t('form.hint.online')
    end

    f.inputs 'Contenu de l\'article' do
      f.translated_inputs 'Translated fields', switch_locale: true do |t|
        t.input :title,
                label: I18n.t('activerecord.attributes.post.title'),
                hint: I18n.t('form.hint.title')
        t.input :content,
                label: I18n.t('activerecord.attributes.post.content'),
                hint: I18n.t('form.hint.content'),
                input_html: { class: 'froala' }
      end
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    cache_sweeper :legal_notice_sweeper

    before_create do |post|
      post.type = post.object.class.name
      post.user_id = current_user.id
    end
  end
end
