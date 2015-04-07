#
# == Abouts Controller
#
class AboutsController < InheritedResources::Base
  # GET /abouts
  # GET /abouts.json
  def index
    @abouts = About.online
    seo_tag_index category
  end
end
