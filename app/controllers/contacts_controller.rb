# frozen_string_literal: true

#
# ContactsController
# ====================
class ContactsController < ApplicationController
  include OptionalModules::QrcodeHelper
  include ModuleSettingable

  skip_before_action :allow_cors,
                     :set_menu_elements,
                     :set_controller_name,
                     :set_pages,
                     :set_current_page,
                     :set_legal_notices,
                     :set_adult_validation,
                     :set_background,
                     :set_newsletter_user,
                     :set_search_autocomplete,
                     :set_slider,
                     :set_social_network,
                     :set_froala_key,
                     only: :mapbox_popup,

                     # Rails 5 fix
                     raise: false

  after_action :set_emails,
               only: [:create],
               if: proc { @contact_form.valid? }

  # GET /contact
  # GET /contact.json
  def index
    redirect_to new_contact_path
  end

  # GET /contact/formulaire
  # GET /contact/formulaire.json
  def new
    @contact_form = ContactForm.new
    seo_tag_index page
  end

  def create
    @contact_form = ContactForm.new(contact_form_params)
    if @contact_form.valid?
      respond_action :create
    else
      render :new
    end
  end

  def mapbox_popup
    if request.xhr?
      if @show_map_contact
        render layout: false
      else
        head :ok
      end
    else
      redirect_to contacts_path
    end
  end

  private

  def contact_form_params
    a = [:name, :email, :message, :send_copy, :nickname]
    a.push(:attachment) if @setting.show_file_upload?
    params.require(:contact_form).permit(a)
  end

  def respond_action(template)
    @success_contact_form = StringBox.includes(:translations).find_by(key: 'success_contact_form')
    flash.now[:success] = sanitize_string(@success_contact_form.content)
    respond_to do |format|
      format.html { redirect_to new_contact_path, notice: @success_contact_form.content }
      format.js { render template }
    end
  end

  def set_emails
    ContactFormMailer.to_admin(@contact_form).deliver_now
    ContactFormMailer.copy(@contact_form).deliver_now if @contact_form.send_copy == '1'
    ContactFormMailer.answering_machine(@contact_form.email, @locale).deliver_now if @setting.answering_machine?
  end
end
