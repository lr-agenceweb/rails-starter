#
# == ContactsController
#
class ContactsController < ApplicationController
  include Mappable
  include MapHelper

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
    @success_contact_form = StringBox.includes(:translations).find_by(key: 'success_contact_form')
    flash.now[:success] = @success_contact_form.content
    respond_to do |format|
      format.html { redirect_to new_contact_path, notice: @success_contact_form.content }
      format.js { render template }
    end
  end
end
