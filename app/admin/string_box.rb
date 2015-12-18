ActiveAdmin.register StringBox do
  menu parent: I18n.t('admin_menu.config')
  includes :translations, :optional_module

  permit_params :id,
                :key,
                :optional_module_id,
                translations_attributes: [
                  :id, :locale, :title, :content
                ]

  decorate_with StringBoxDecorator
  config.clear_sidebar_sections!

  index do
    column :key if current_user.super_administrator?
    column :description
    column :title
    column :content
    column :optional_module if current_user.super_administrator?

    translation_status
    actions
  end

  show title: :title_aa_show do
    attributes_table do
      row :key if current_user.super_administrator?
      row :description
      row :title
      row :content
      row :optional_module if current_user.super_administrator?
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs t('activerecord.models.string_box.one') do
      if current_user.super_administrator?
        if f.object.new_record?
          f.input :key
        else
          f.input :key, input_html: { disabled: :disabled }
        end
      end

      f.translated_inputs 'Translated fields', switch_locale: false do |t|
        t.input :title,
                hint: I18n.t('form.hint.string_box.title'),
                label: I18n.t('activerecord.attributes.post.title')
        t.input :content,
                hint: I18n.t('form.hint.string_box.content'),
                label: I18n.t('activerecord.attributes.post.content'),
                input_html: { class: 'froala' }
      end

      if current_user.super_administrator?
        f.input :optional_module_id,
                as: :select,
                label: I18n.t('activerecord.attributes.string_box.optional_module'),
                collection: OptionalModule.all.map { |m| [m.decorate.name_deco, m.id] },
                include_blank: true,
                input_html: {
                  class: 'chosen-select'
                }
      end
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include Skippable

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
      params[:string_box].delete :optional_module_id unless current_user.super_administrator?
    end
  end
end
