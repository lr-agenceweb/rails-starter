#
# == ContactsController
#
class ContactsController < ApplicationController
  before_action :set_mapbox_options, only: [:new, :create], if: proc { !map.nil? && map.show_map? }
  skip_before_action :allow_cors

  # GET /contact
  # GET /contact.json
  def index
    redirect_to new_contact_path
  end

  # GET /contact/formulaire
  # GET /contact/formulaire.json
  def new
    @contact_form = ContactForm.new
    seo_tag_index category
  end

  def create
    if params[:contact_form][:nickname].blank?
      @contact_form = ContactForm.new(params[:contact_form])
      @contact_form.request = request
      if @contact_form.deliver
        respond_action :create
      else
        render :new
      end
    else
      respond_action :create
    end
  end

  private

  def respond_action(template)
    flash.now[:success] = I18n.t('contact.success')
    respond_to do |format|
      format.html { redirect_to new_contact_path, notice: I18n.t('contact.success') }
      format.js { render template }
    end
  end

  def set_mapbox_options
    mapbox_gon_params
  end
end
