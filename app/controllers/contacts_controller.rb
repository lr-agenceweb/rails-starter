#
# == ContactsController
#
class ContactsController < InheritedResources::Base
  # before_action :set_content_boxes, only: [:new, :create]
  before_action :set_mapbox_options, only: [:new, :create], if: proc { Setting.first.show_map }
  skip_before_action :allow_cors

  def index
    redirect_to new_contact_path
  end

  def new
    @contact = Contact.new
    # seo_tag_index(category, @background)
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      # flash[:success] = @content_boxes.find_by(tag: 'message_success').content
      flash[:success] = 'Succès !'
      redirect_to :back
    else
      render :new
    end
  end

  private

  def set_content_boxes
    @content_boxes = ContentBox.for_model(controller_name.classify)
  end

  def set_mapbox_options
    setting = Setting.first
    gon.push(
      mapbox_username: Figaro.env.mapbox_username,
      mapbox_key: Figaro.env.mapbox_map_key,
      mapbox_access_token: Figaro.env.mapbox_access_token,
      name: setting.name,
      subtitle: setting.subtitle,
      address: setting.address,
      city: setting.city,
      postcode: setting.postcode,
      latitude: setting.latitude,
      longitude: setting.longitude
      )
  end
end
