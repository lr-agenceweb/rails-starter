#
# == Abouts Controller
#
class AboutsController < InheritedResources::Base
  decorates_assigned :about
  before_action :set_about, only: [:show]

  # GET /abouts
  # GET /abouts.json
  def index
    @abouts = About.online
    seo_tag_index category
  end

  def show
    seo_tag_show @about
  end

  private

  def set_about
    @about = About.friendly.find(params[:id])
    @element = @about
  end
end
