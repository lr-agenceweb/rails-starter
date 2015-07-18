ActiveAdmin.register StringBox do
  includes :translations

  permit_params :id,
                :key,
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

  show do
    attributes_table do
      row :key
      row :title
      row :content
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Custom contenu' do
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
    end

    f.actions
  end
end
