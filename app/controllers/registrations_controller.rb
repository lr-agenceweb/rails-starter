# frozen_string_literal: true

#
# == Registrations Controller
#
class RegistrationsController < ActiveAdmin::Devise::RegistrationsController
  def sign_up(_resource_name, _resource)
    true
  end

  def after_sign_up_path_for(_resource)
    flash[:notice] = t('user.registration.not_activated')
    root_url
  end
end
