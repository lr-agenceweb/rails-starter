#
# == Users namespace
#
module Users
  #
  # == OmniauthCallbacks controller
  #
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :redirect_to_user, only: :unlink, if: :should_redirect?

    def facebook
      redirect_to '/admin/auth/facebook?auth_type=rerequest&scope=email' if request.env['omniauth.auth'].info.email.blank?
      omniauth_providers 'facebook'
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
      @errors = User.check_for_errors(request.env['omniauth.auth'], current_user)
      if @errors.empty?
        @user = User.link_with_omniauth(request.env['omniauth.auth'], current_user)
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
        do_magick
      end
    end

    def do_magick
      sign_in @user, event: :authentication
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: @provider.capitalize if is_navigational_format?
      redirect_to admin_user_path(@user)
    end

    def redirect_to_user
      redirect_to admin_user_path(current_user), alert: I18n.t('omniauth.unlink.alert.wrong_identity')
    end

    def should_redirect?
      !(params[:id].to_s == current_user.id.to_s && current_user.from_omniauth?)
    end

    # def omniauth_providers(provider)
    #   @user = User.from_omniauth(request.env['omniauth.auth'])

    #   if @user.persisted?
    #     sign_in_and_redirect @user, event: :authentication
    #     flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: provider.capitalize if is_navigational_format?
    #   else
    #     session["devise.#{provider}_data"] = request.env['omniauth.auth']
    #     redirect_to new_user_registration_url
    #   end
    # end
  end
end
