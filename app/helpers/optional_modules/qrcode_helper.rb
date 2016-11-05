# frozen_string_literal: false

#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == QrcodeHelper
  #
  module QrcodeHelper
    include ERB::Util

    def qrcode_image_tag(size = 200)
      image_tag qrcode_base_url(size), alt: 'QrCode'
    end

    private

    def qrcode_base_url(size)
      "http://chart.apis.google.com/chart?chs=#{size}x#{size}&cht=qr&chl=#{u vcard}"
    end

    def vcard
      html = "BEGIN:VCARD\n"
      html << "VERSION:3.0\n"
      html << set_name + set_phone + set_address
      html << set_organization + set_email + set_url
      html << 'END:VCARD'
    end

    def set_name
      "N:#{@setting.name}\n" + "FN:#{@setting.name}\n"
    end

    def set_phone
      "TEL;WORK:#{@setting.phone}\n"
    end

    def set_address
      location = @map_setting.location.try(:decorate)
      return '' if location.nil?
      "ADR;WORK:;;#{location.address};#{location.city};;#{location.postcode};France\n"
    end

    def set_organization
      "ORG:#{@setting.decorate.title_subtitle_inline}\n"
    end

    def set_email
      "EMAIL:#{@setting.email}\n"
    end

    def set_url
      "URL:#{root_url}\n"
    end
  end
end
