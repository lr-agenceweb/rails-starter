# frozen_string_literal: true
#
# == Users namespace
#
module Users
  #
  # == OmniauthCallbacks controller
  #
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :not_found, if: :module_or_provider_disabled?
    before_action :redirect_to_user, only: :unlink, if: :should_redirect?
    before_action :check_for_errors, except: :unlink, if: proc { signed_in? }
    skip_before_action :verify_authenticity_token, only: :unlink

    def facebook
      redirect_to '/admin/auth/facebook?auth_type=rerequest&scope=email' if request.env['omniauth.auth'].info.email.blank?
      omniauth_providers 'facebook'
    end

    def twitter
      request.env['omniauth.auth']['info']['email'] = current_user.email if signed_in?
      omniauth_providers 'twitter'
    end

    def google_oauth2
      omniauth_providers 'google'
    end

    def unlink
      @user = current_user
      @user.update_attributes(provider: nil, uid: nil)
      sign_in @user, event: :authentication
      flash[:notice] = I18n.t('omniauth.unlink.alert.success', provider: params[:provider].capitalize)
      redirect_to admin_user_path(@user)
    end

    private

    def omniauth_providers(provider)
      @provider = provider
      link_me_with_omniauth if signed_in?
      connect_me_from_omniauth unless signed_in?
    end

    def link_me_with_omniauth
      if @errors.empty?
        @user = current_user.link_with_omniauth(request.env['omniauth.auth'])
        sign_out @user
        do_magick
      else
        @error = @errors[:wrong_email].blank? ? @errors[:already_linked] : @errors[:wrong_email]
        redirect_to admin_user_path(current_user), alert: @error
      end
    end

    def connect_me_from_omniauth
      @user = User.find_by_provider_and_uid(request.env['omniauth.auth'])
      if @user.blank? || !@user.persisted?
        redirect_to new_user_session_path, alert: I18n.t('omniauth.login.not_exist', provider: @provider.capitalize)
      else
        @user.update_infos_since_last_connection request.env['omniauth.auth']
        do_magick admin_dashboard_path
      end
    end

    def do_magick(redirect = admin_user_path(@user))
      sign_in @user, event: :authentication
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: @provider.capitalize if is_navigational_format?
      redirect_to redirect
    end

    def redirect_to_user
      redirect_to admin_user_path(current_user), alert: I18n.t('omniauth.unlink.alert.wrong_identity')
    end

    def should_redirect?
      !(params[:id].to_s == current_user.id.to_s && current_user.from_omniauth?(params[:provider]))
    end

    def not_found
      raise ActionController::RoutingError, 'Not Found'
    end

    def module_or_provider_disabled?(provider = params[:action])
      provider = provider == 'unlink' ? params[:provider] : provider
      !SocialProvider.find_by(name: SocialProvider.format_provider_by_name(provider)).enabled? || !SocialProvider.allowed_to_use?
    end

    def check_for_errors
      @errors = User.check_for_errors(request.env['omniauth.auth'], current_user)
    end
  end
end
