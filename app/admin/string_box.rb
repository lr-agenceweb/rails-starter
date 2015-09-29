ActiveAdmin.register StringBox do
  includes :translations

  permit_params :id,
                :key,
                :optional_module_id,
                translations_attributes: [
                  :id, :locale, :title, :content
                ]

  decorate_with StringBoxDecorator
  config.clear_sidebar_sections!

  index do
    column :key
    column :title
    column :content

    translation_status
    actions
  end

  show title: :title_aa_show do
    attributes_table do
      row :key
      row :title
      row :content
      row :optional_module if current_user.super_administrator?
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs t('activerecord.models.string_box.one') do
      if f.object.new_record?
        f.input :key
      else
        f.input :key, input_html: { disabled: :disabled }
      end

      f.translated_inputs 'Translated fields', switch_locale: false do |t|
        t.input :title, hint: I18n.t('form.hint.string_box.title')
        t.input :content,
                hint: I18n.t('form.hint.string_box.content'),
                input_html: { class: 'froala' }
      end

      if current_user.super_administrator?
        f.input :optional_module_id,
                as: :select,
                collection: OptionalModule.all,
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
  end
end
