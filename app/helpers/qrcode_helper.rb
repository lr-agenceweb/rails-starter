#
# == QrcodeHelper
#
module QrcodeHelper
  def vcard
    location = map.location.decorate

    html = "BEGIN:VCARD\n"
    html << "VERSION:3.0\n"
    html << "N:#{setting.name}\n"
    html << "FN:#{setting.name}\n"
    html << "TEL;WORK:#{setting.phone}\n"
    html << "ADR;WORK:;;#{location.address};#{location.city};;#{location.postcode};France\n"
    # html << "GEO:#{location.latitude};#{location.longitude}\n"
    html << "ORG:#{setting.title_subtitle_inline}\n"
    html << "EMAIL:#{setting.email}\n"
    html << "URL:#{request.protocol + request.host_with_port}\n"
    html << "END:VCARD"
    html
  end
end
