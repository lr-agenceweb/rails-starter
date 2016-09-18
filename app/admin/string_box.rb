# frozen_string_literal: true
ActiveAdmin.register StringBox do
  menu parent: I18n.t('admin_menu.config')
  includes :translations, :optional_module

  permit_params do
    params = [:id,
              :key,
              translations_attributes: [
                :id, :locale, :title, :content
              ]]

    params.push :optional_module_id if current_user.super_administrator?
    params
  end

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
    arbre_cache(self, resource.cache_key) do
      attributes_table do
        row :key if current_user.super_administrator?
        row :description
        row :title
        row :content
        row :optional_module if current_user.super_administrator?
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.columns do
      f.column do
        f.inputs t('general') do
          if f.object.new_record?
            f.input :key
          else
            f.input :key, input_html: { disabled: :disabled }
          end

          f.input :optional_module_id,
                  as: :select,
                  label: I18n.t('activerecord.attributes.string_box.optional_module'),
                  collection: OptionalModule.all.map { |m| [m.decorate.name, m.id] },
                  include_blank: true
        end
      end
    end if current_user.super_administrator?

    f.columns do
      f.column do
        f.inputs t('activerecord.attributes.string_box.description') do
          "<li><p>#{f.object.description}</p></li>".html_safe
        end
      end
    end

    f.columns do
      f.column do
        f.inputs t('activerecord.models.string_box.one') do
          f.translated_inputs 'Translated fields', switch_locale: false do |t|
            t.input :title,
                    hint: I18n.t('form.hint.string_box.title'),
                    label: I18n.t('activerecord.attributes.post.title')
            t.input :content,
                    hint: I18n.t('form.hint.string_box.content'),
                    label: I18n.t('activerecord.attributes.post.content'),
                    input_html: { class: 'froala' }
          end
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
