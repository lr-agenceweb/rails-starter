#
# == Abouts Controller
#
class AboutsController < InheritedResources::Base

  # GET /abouts
  # GET /abouts.json
  def index
    @abouts = About.online
  end
end
