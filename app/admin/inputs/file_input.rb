# frozen_string_literal: true
#
# == FileInput helper
#
class FileInput < Formtastic::Inputs::FileInput
  def to_html
    input_wrapping do
      label_html <<
        builder.file_field(method, input_html_options) <<
        avatar_preview_content
    end
  end

  private

  def avatar_preview_content
    avatar_preview? ? avatar_preview_html : ''
  end

  def avatar_preview?
    options[:avatar_preview] && @object.send(method).present?
  end

  def avatar_preview_html
    template.retina_image_tag(@object, :avatar, :small)
  end
end
