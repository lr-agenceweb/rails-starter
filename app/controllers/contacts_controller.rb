#
# == ContactsController
#
class ContactsController < ApplicationController
  include Mappable
  include MapHelper
  include QrcodeHelper

  skip_before_action :allow_cors
  skip_before_action :set_menu_elements, :set_adult_validation, :set_background, :set_newsletter_user, :set_search_autocomplete, :set_slider, :set_social_network, :set_froala_key, only: :mapbox_popup

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
      @contact_form = ContactForm.new(contact_form_params)
      if @contact_form.valid?
        ContactFormMailer.message_me(@contact_form).deliver_now
        ContactFormMailer.send_copy(@contact_form).deliver_now if @contact_form.send_copy == '1'
        respond_action :create
      else
        render :new
      end
    else
      respond_action :create
    end
  end

  def mapbox_popup
    if request.xhr?
      render layout: false
    else
      redirect_to contacts_path
    end
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(:name, :email, :message, :send_copy)
  end

  def respond_action(template)
    @success_contact_form = StringBox.includes(:translations).find_by(key: 'success_contact_form')
    flash.now[:success] = @success_contact_form.content
    respond_to do |format|
      format.html { redirect_to new_contact_path, notice: @success_contact_form.content }
      format.js { render template }
    end
  end
end
