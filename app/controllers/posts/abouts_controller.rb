#
# == Abouts Controller
#
class AboutsController < InheritedResources::Base
  # GET /home
  # GET /home.json
  def index
    @abouts = About.online
  end
end
