# frozen_string_literal: true

#
# == Registrations Controller
#
class RegistrationsController < ActiveAdmin::Devise::RegistrationsController
  protected

  def sign_up(_resource_name, _resource)
    true
  end

  def after_sign_up_path_for(_resource)
    flash[:notice] = 'Votre compte a bien été créé, vous pourrez vous connecter quand admin aura validé'
    blogs_path
  end
end
