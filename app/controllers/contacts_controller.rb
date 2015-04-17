#
# == ContactsController
#
class ContactsController < InheritedResources::Base
  before_action :set_setting
  before_action :set_mapbox_options, only: [:new, :create], if: proc { @setting.show_map }
  skip_before_action :allow_cors

  def index
    redirect_to new_contact_path
  end

  def new
    @contact_form = ContactForm.new
    seo_tag_index category
  end

  def create
    @contact_form = ContactForm.new(params[:contact_form])
    @contact_form.request = request
    if @contact_form.deliver
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
    gon_params
  end

  def set_setting
    @setting ||= Setting.first
  end
end
